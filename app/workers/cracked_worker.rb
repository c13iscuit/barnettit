class CrackedWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    hourly(5)
  end

  def perform
    client = Importio::new("faee0006-f55e-41ed-b774-f968b8654dc9", ENV["IMPORTIO_KEY"])
    client.connect

    data_rows = []

    callback = lambda do |query, message|
      if message["type"] == "DISCONNECT"
        puts "The query was cancelled as the client was disconnected"
      end
      if message["type"] == "MESSAGE"
        if message["data"].key?("errorType")
          puts "Got an error!"
          puts JSON.pretty_generate(message["data"])
        else
          puts "Got data!"
          puts JSON.pretty_generate(message["data"])
          data_rows << message["data"]["results"]
        end
      end
      if query.finished
        puts "Query finished"
      end
    end

    client.query({"input"=>{"webpage/url"=>"http://www.cracked.com/"},"connectorGuids"=>["1926bc09-ba86-474d-8692-4a86744c0cc2"]}, callback )

    puts "Queries dispatched, now waiting for results"

    client.join

    puts "Join completed, all results returned"

    client.disconnect

    post = Post.new(title: data_rows[0][0]["article_link/_text"], url: data_rows[0][0]["article_link"], user_id: 8, source: "cracked", avatar: "cracked_logo.png")
    post.save
    post1 = Post.new(title: data_rows[0][1]["article_link/_text"], url: data_rows[0][1]["article_link"], user_id: 8, source: "cracked", avatar: "cracked_logo.png")
    post1.save
  end
end
