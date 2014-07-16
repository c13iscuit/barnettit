class CrackedWorker
  include Sidekiq::Worker
  # include Sidetiq::Schedulable

  # recurrence do
  #   hourly(4)
  # end

  def perform
    client = Importio::new("faee0006-f55e-41ed-b774-f968b8654dc9","Tt4ddzcUp6LNFIjxpODUUZFlYCwEqL0RQ4VYrae6qtolYpx1Jv5VLtnL53gAovuwNce4shSEXRyH5t7ovAocJQ==")
    client.connect

    # Define here a global variable that we can put all our results in to when they come back from
    # the server, so we can use the data later on in the script
    data_rows = []

    # In order to receive the data from the queries we issue, we need to define a callback method
    # This method will receive each message that comes back from the queries, and we can take that
    # data and store it for use in our app
    callback = lambda do |query, message|
      # Disconnect messages happen if we disconnect the client library while a query is in progress
      if message["type"] == "DISCONNECT"
        puts "The query was cancelled as the client was disconnected"
      end
      if message["type"] == "MESSAGE"
        if message["data"].key?("errorType")
          # In this case, we received a message, but it was an error from the external service
          puts "Got an error!"
          puts JSON.pretty_generate(message["data"])
        else
          # We got a message and it was not an error, so we can process the data
          puts "Got data!"
          puts JSON.pretty_generate(message["data"])
          # Save the data we got in our dataRows variable for later
          data_rows << message["data"]["results"]
        end
      end
      if query.finished
        puts "Query finished"
      end
    end

    # Issue queries to your data sources with your specified inputs
    # You can modify the inputs and connectorGuids so as to query your own sources
    # Query for tile cracked
    client.query({"input"=>{"webpage/url"=>"http://www.cracked.com/"},"connectorGuids"=>["1926bc09-ba86-474d-8692-4a86744c0cc2"]}, callback )

    puts "Queries dispatched, now waiting for results"

    # Now we have issued all of the queries, we can wait for all of the threads to complete meaning the queries are done
    client.join

    puts "Join completed, all results returned"

    # It is best practice to disconnect when you are finished sending queries and getting data - it allows us to
    # clean up resources on the client and the server
    client.disconnect

    # Now we can print out the data we got
    puts "#{data_rows}"

    post = Post.new(title: data_rows[0][0]["article_link/_text"], url: data_rows[0][0]["article_link"], user_id: 8)
    post.save
    post1 = Post.new(title: data_rows[0][1]["article_link/_text"], url: data_rows[0][1]["article_link"], user_id: 8)
    post1.save
  end
end
