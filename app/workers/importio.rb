#
# import.io client library - client classes
#
# This file contains the main classes required to connect to and query import.io APIs
#
# Dependencies: Ruby 1.9, http-cookie
#
# @author: dev@import.io
# @source: https://github.com/import-io/importio-client-libs/tree/master/python
#

require "net/http"
require "uri"
require "thread"
require "http-cookie"
require "cgi"
require "json"
require "securerandom"

class Query
  # This class represents a single query to the import.io platform

  def initialize(callback, query)
    # Initialises the new query object with inputs and default state
    @query = query
    @jobs_spawned = 0
    @jobs_started = 0
    @jobs_completed = 0
    @_finished = false
    @_callback = callback
  end

  def _on_message(data)
    # Method that is called when a new message is received
    #
    # Check the type of the message to see what we are working with
    msg_type = data["type"]
    if msg_type == "SPAWN"
      # A spawn message means that a new job is being initialised on the server
      @jobs_spawned+=1
    elsif msg_type == "INIT" or msg_type == "START"
      # Init and start indicate that a page of work has been started on the server
      @jobs_started+=1
    elsif msg_type == "STOP"
      # Stop indicates that a job has finished on the server
      @jobs_completed+=1
    end

    # Update the finished state
    # The query is finished if we have started some jobs, we have finished as many as we started, and we have started as many as we have spawned
    # There is a +1 on jobs_spawned because there is an initial spawn to cover initialising all of the jobs for the query
    @_finished = (@jobs_started == @jobs_completed and @jobs_spawned + 1 == @jobs_started and @jobs_started > 0)

    # These error conditions mean the query has been terminated on the server
    # It either errored on the import.io end, the user was not logged in, or the query was cancelled on the server
    if msg_type == "ERROR" or msg_type == "UNAUTH" or msg_type == "CANCEL"
      @_finished = true
    end

    # Now we have processed the query state, we can return the data from the message back to listeners
    @_callback.call(self, data)
  end

  def finished
    # Returns boolean - true if the query has been completed or terminated
    return @_finished
  end
end

class Importio
  # The main import.io client, used for managing the message channel and sending queries and receiving data

  def initialize(user_id=nil, api_key=nil, host="https://query.import.io")
    # Initialises the client library with its configuration
    @host = host
    @proxy_host = nil
    @proxy_port = nil
    @user_id = user_id
    @api_key = api_key
    @username = nil
    @password = nil
    @login_host = nil
    @session = nil
    @queue = Queue.new
  end

  # We use this only for a specific test case
  attr_reader :session

  def proxy(host, port)
    # If you want to configure an HTTP proxy, use this method to do so
    @proxy_host = host
    @proxy_port = port
  end

  def login(username, password, host="https://api.import.io")
    # If you want to use cookie-based authentication, this method will log you in with a username and password to get a session
    @username = username
    @password = password
    @login_host = host

    # If we don't have a session, then connect one
    if @session == nil
      connect()
    end

    # Once connected, do the login
    @session.login(@username, @password, @login_host)
  end

  def reconnect
    # Reconnects the client to the platform by establishing a new session

    # Disconnect an old session, if there is one
    if @session != nil
      disconnect()
    end

    if @username != nil
      login(@username, @password, @login_host)
    else
      connect()
    end
  end

  def connect
    # Connect this client to the import.io server if not already connected

    # Check if there is a session already first
    if @session != nil
      return
    end

    @session = Session::new(self, @host, @user_id, @api_key, @proxy_host, @proxy_port)
    @session.connect()

    # This should be a @queue.clone, but this errors in 2.1 branch of Ruby: #9718
    # q = @queue.clone
    q = Queue.new
    until @queue.empty?
      q.push(@queue.pop(true))
    end
    @queue = Queue.new

    until q.empty?
      query_data = q.pop(true) rescue nil
      if query_data
        query(query_data.query, query_data.callback)
      end
    end
  end

  def disconnect
    # Call this method to ask the client library to disconnect from the import.io server
    # It is best practice to disconnect when you are finished with querying, so as to clean
    # up resources on both the client and server

    if @session != nil
      @session.disconnect()
      @session = nil
    end
  end

  def stop
    # This method stops all of the threads that are currently running in the session
    if @session != nil
      return @session.stop()
    end
  end

  def join
    # This method joins the threads that are running together in the session, so we can wait for them to be finished
    if @session != nil
      return @session.join()
    end
  end

  def query(query, callback)
    # This method takes an import.io Query object and either queues it, or issues it to the server
    # depending on whether the session is connected

    if @session == nil || !@session.connected
      @queue << {"query"=>query,"callback"=>callback}
      return
    end

    @session.query(query, callback)
  end

end

class Session
  # Session manager, used for managing the message channel, sending queries and receiving data

  def initialize(io, host="https://query.import.io", user_id=nil, api_key=nil, proxy_host=nil, proxy_port=nil)
    # Initialises the client library with its configuration
    @io = io
    @msg_id = 1
    @client_id = nil
    @url = "#{host}/query/comet/"
    @messaging_channel = "/messaging"
    @queries = Hash.new
    @user_id = user_id
    @api_key = api_key
    @queue = Queue.new
    @connected = false
    @connecting = false
    @disconnecting = false
    @polling = false
    # These variables serve to identify this client and its version to the server
    @clientName = "import.io Ruby client"
    @clientVersion = "2.0.0"
    @cj = HTTP::CookieJar.new
    @proxy_host = proxy_host
    @proxy_port = proxy_port
  end

  # We use this only for a specific test case
  attr_reader :client_id
  attr_writer :client_id
  attr_reader :connected

  def make_request(url, data)
    # Helper method that generates a request object
    uri = URI(url)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = data
    http = Net::HTTP.new(uri.host, uri.port, @proxy_host, @proxy_port)
    http.use_ssl = uri.scheme == "https"
    return uri, http, request
  end

  def open(uri, http, request)
    # Makes a network request
    response = http.request(request)
    cookies = response.get_fields("set-cookie")
    if cookies != nil
      cookies.each { |value|
        @cj.parse(value, uri)
      }
    end
    return response
  end

  def encode(dict)
    # Encodes a dictionary to x-www-form format
    dict.map{|k,v| "#{CGI.escape(k)}=#{CGI.escape(v)}"}.join("&")
  end

  def login(username, password, host="https://api.import.io")
    # If you want to use cookie-based authentication, this method will log you in with a username and password to get a session
    data = encode({'username' => username, 'password'=> password})
    uri, http, req = make_request("#{host}/auth/login", data )
    r = open(uri, http, req)

    if r.code != "200"
      raise "Could not log in, code #{r.code}"
    end
  end

  def request(channel, path="", data={}, throw=true)
    # Helper method that makes a generic request on the messaging channel

    # These are CometD configuration values that are common to all requests we need to send
    data["channel"] = channel
    data["connectionType"] = "long-polling"

    # We need to increment the message ID with each request that we send
    data["id"] = @msg_id
    @msg_id += 1

    # If we have a client ID, then we need to send that (will be provided on handshake)
    if @client_id != nil
      data["clientId"] = @client_id
    end

    # Build the URL that we are going to request
    url = "#{@url}#{path}"

    # If the user has chosen API key authentication, we need to send the API key with each request
    if @api_key != nil
      q = encode({ "_user" => @user_id, "_apikey" => @api_key })
      url = "#{url}?#{q}"
    end

    # Build the request object we are going to use to initialise the request
    body = JSON.dump([data])
    uri, http, request = make_request(url, body)
    request.content_type = "application/json;charset=UTF-8"
    request["Cookie"] = HTTP::Cookie.cookie_value(@cj.cookies(uri))
    request["import-io-client"] = @clientName
    request["import-io-client-version"] = @clientVersion

    # Send the request itself
    response = open(uri, http, request)

    # Don't process the response if we've disconnected in the meantime
    if !@connected and !@connecting
      return
    end

    # If the server responds non-200 we have a serious issue (configuration wrong or server down)
    if response.code != "200"
      error_message = "Unable to connect to import.io, status #{response.code} for url #{url}"
      if throw
        raise error_message
      else
        puts error_message
      end
    end

    response.body = JSON.parse(response.body)

    # Iterate through each of the messages in the response content
    for msg in response.body do
      # If the message is not successful, i.e. an import.io server error has occurred, decide what action to take
      if msg.has_key?("successful") and msg["successful"] != true
        error_message = "Unsuccessful request: #{msg}"
        if !@disconnecting and @connected and !@connecting
          # If we get a 402 unknown client we need to reconnect
          if msg["error"] == "402::Unknown client"
            puts "402 received, reconnecting"
            @io.reconnect()
          elsif throw
            raise error_message
          else
            puts error_message
          end
        else
          next
        end
      end

      # Ignore messages that come back on a CometD channel that we have not subscribed to
      if msg["channel"] != @messaging_channel
        next
      end

      # Now we have a valid message on the right channel, queue it up to be processed
      @queue.push(msg["data"])
    end

    return response
  end

  def handshake
    # This method uses the request helper to make a CometD handshake request to register the client on the server
    handshake = request("/meta/handshake", path="handshake", data={"version"=>"1.0","minimumVersion"=>"0.9","supportedConnectionTypes"=>["long-polling"],"advice"=>{"timeout"=>60000,"interval"=>0}})

    if handshake == nil
      return
    end

    # Set the Client ID from the handshake's response
    @client_id = handshake.body[0]["clientId"]
  end

  def subscribe(channel)
    # This method uses the request helper to issue a CometD subscription request for this client on the server
    return request("/meta/subscribe", "", {"subscription"=>channel})
  end

  def connect
    # Connect this client to the import.io server if not already connected
    # Don't connect again if we're already connected
    if @connected || @connecting
      return
    end

    @connecting = true

    # Do the hanshake request to register the client on the server
    handshake

    # Register this client with a subscription to our chosen message channel
    subscribe(@messaging_channel)

    # Now we are subscribed, we can set the client as connected
    @connected = true

    # Ruby's HTTP requests are synchronous - so that user apps can run while we are waiting for long connections
    # from the import.io server, we need to pass the long-polling connection off to a thread so it doesn't block
    # anything else
    @threads = []
    @threads << Thread.new(self) { |context|
      context.poll
    }

    # Similarly with the polling, we need to handle queued messages in a separate thread too
    @threads << Thread.new(self) { |context|
      context.poll_queue
    }

    @connecting = false
  end

  def disconnect
    # Call this method to ask the client library to disconnect from the import.io server
    # It is best practice to disconnect when you are finished with querying, so as to clean
    # up resources on both the client and server

    # Maintain a local value of the queries, and then erase them from the class
    q = @queries.clone
    @queries = Hash.new

    # Set the flag to notify handlers that we are disconnecting, i.e. open connect calls will fail
    @disconnecting = true

    # Set the connection status flag in the library to prevent any other requests going out
    @connected = false

    # Make the disconnect request to the server
    request("/meta/disconnect");

    # Now we are disconnected we need to remove the client ID
    @client_id = nil

    # We are done disconnecting so reset the flag
    @disconnecting = false

    # Send a "disconnected" message to all of the current queries, and then remove them
    q.each { |key, query|
      query._on_message({"type"=>"DISCONNECT","requestId"=>key})
    }
  end

  def stop
    # This method stops all of the threads that are currently running
    @threads.each { |thread|
      thread.terminate
    }
  end

  def join
    # This method joins the threads that are running together, so we can wait for them to be finished
    while @connected
      if @queries.length == 0
        # When there are no more queries, stop all the threads
        stop()
        return
      end
      sleep 1
    end
  end

  def poll_queue
    # This method is called in a new thread to poll the queue of messages returned from the server
    # and process them

    # This while will mean the thread keeps going until the client library is disconnected
    while @connected
      begin
        # Attempt to process the last message on the queue
        process_message @queue.pop
      rescue => exception
        puts exception.backtrace
      end
    end
  end

  def poll
    # This method is called in a new thread to open long-polling HTTP connections to the import.io
    # CometD server so that we can wait for any messages that the server needs to send to us

    if @polling
      return
    end

    @polling = true

    # While loop means we keep making connections until manually disconnected
    while @connected
      # Use the request helper to make the connect call to the CometD endpoint
      request("/meta/connect", "connect", {}, false)
    end

    @polling = false
  end

  def process_message(data)
    # This method is called by the queue poller to handle messages that are received from the import.io
    # CometD server
    begin
      # First we need to look up which query object the message corresponds to, based on its request ID
      request_id = data["requestId"]
      query = @queries[request_id]

      # If we don't recognise the client ID, then do not process the message
      if query == nil
        puts "No open query #{query}:"
        puts JSON.pretty_generate(data)
        return
      end

      # Call the message callback on the query object with the data
      query._on_message(data)

      # Clean up the query map if the query itself is finished
      if query.finished
        @queries.delete(request_id)
      end
    rescue => exception
      puts exception.backtrace
    end
  end

  def query(query, callback)
    # This method takes an import.io Query object and issues it to the server, calling the callback
    # whenever a relevant message is received

    # Set the request ID to a random GUID
    # This allows us to track which messages correspond to which query
    query["requestId"] = SecureRandom.uuid
    # Construct a new query state tracker and store it in our map of currently running queries
    @queries[query["requestId"]] = Query::new(callback, query)
    # Issue the query to the server
    request("/service/query", "", { "data"=>query })
  end

end
