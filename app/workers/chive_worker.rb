class ChiveWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    hourly(2)
  end

  def perform
    client = Importio::new("faee0006-f55e-41ed-b774-f968b8654dc9", ENV["IMPORTIO_KEY"])
    client.connect

    data_rows = []

    callback = lambda do |query, message|
      if message["type"] == "DISCONNECT"
        logger.error "The query was cancelled as the client was disconnected"
      end
      if message["type"] == "MESSAGE"
        if message["data"].key?("errorType")
          logger.error "Got an error!"
          puts JSON.pretty_generate(message["data"])
        else
          logger.info "Got data!"
          puts JSON.pretty_generate(message["data"])
          data_rows << message["data"]["results"]
        end
      end
      if query.finished
        logger.info "Query finished"
      end
    end

    client.query({"input"=>{"webpage/url"=>"http://thechive.com/"},"connectorGuids"=>["8536e9e2-50f7-40a8-a872-738dc7729715"]}, callback )

    logger.info "Queries dispatched, now waiting for results"

    client.join

    logger.info "Join completed, all results returned"

    client.disconnect

    position = 0
    counter = 0
    while counter < 2 && position < data_rows[0].length
      post = Post.new(title: data_rows[0][position]["thechive/_text"].gsub("\t",''), url: data_rows[0][position]["thechive"], user_id: 8)
      if post.save
        counter += 1
      end
      position += 1
    end
  end
end
