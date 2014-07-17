class ChiveWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    hourly(3)
  end

  def perform
    client = Importio::new("faee0006-f55e-41ed-b774-f968b8654dc9","Tt4ddzcUp6LNFIjxpODUUZFlYCwEqL0RQ4VYrae6qtolYpx1Jv5VLtnL53gAovuwNce4shSEXRyH5t7ovAocJQ==")
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

    client.query({"input"=>{"webpage/url"=>"http://thechive.com/"},"connectorGuids"=>["8536e9e2-50f7-40a8-a872-738dc7729715"]}, callback )

    puts "Queries dispatched, now waiting for results"

    client.join

    puts "Join completed, all results returned"

    client.disconnect

    post = Post.new(title: data_rows[0][0]["thechive/_text"].gsub("\t",''), url: data_rows[0][0]["thechive"], user_id: 8)
    post.save
    post1 = Post.new(title: data_rows[0][1]["thechive/_text"].gsub("\t",''), url: data_rows[0][1]["thechive"], user_id: 8)
    post1.save
  end
end
