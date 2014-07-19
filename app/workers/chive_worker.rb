class ChiveWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    hourly(3)
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

    post = Post.new(title: data_rows[0][0]["thechive/_text"].gsub("\t",''), url: data_rows[0][0]["thechive"], user_id: 8, source_id: 2, avatar: "chive_logo.jpg")
    post.save
    post = Post.new(title: data_rows[0][1]["thechive/_text"].gsub("\t",''), url: data_rows[0][1]["thechive"], user_id: 8, source_id: 2, avatar: "chive_logo.jpg")
    post.save

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

    client.query({"input"=>{"webpage/url"=>"http://trailers.apple.com/trailers/"},"connectorGuids"=>["f182b831-3b02-4f84-b9a3-f84e3fa8ab4f"]}, callback )

    logger.info "Queries dispatched, now waiting for results"

    client.join

    logger.info "Join completed, all results returned"

    client.disconnect

    post = Post.new(title: data_rows[0][0]["trailers/_title"].gsub("\t",''), url: data_rows[0][0]["trailers"], user_id: 8, source_id: 3, avatar: "trailer_logo.jpg")
    post.save
    post = Post.new(title: data_rows[0][1]["trailers/_title"].gsub("\t",''), url: data_rows[0][1]["trailers"], user_id: 8, source_id: 3, avatar: "trailer_logo.jpg")
    post.save
  end
end
