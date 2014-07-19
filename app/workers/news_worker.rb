class NewsWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    hourly(4)
  end

  def perform
    uri = URI("http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/1.json?api-key=#{ENV["NYT"]}")
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)
    top = result["results"].take(1)
    top.each do |article|
      post = Post.new(title: article["title"], url: article["url"], user_id: 8, source_id: 6, avatar: "nyt_logo.jpg")
      post.save
    end

    uri = URI("http://betawebapi.dowjones.com/fintech/articles/api/v1/source/424/?count=3")
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)
    top = result["Headlines"].take(1)
    top.each do |article|
      post = Post.new(title: article["Headline"], url: article["ExternalLink"], user_id: 8, source_id: 7, avatar: "wsj_logo.gif")
      post.save
    end

    uri = URI("http://api.espn.com/v1/sports/news/headlines/top?apikey=#{ENV["ESPN_KEY"]}")
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)
    top = result["headlines"].take(1)
    top.each do |article|
      post = Post.new(title: article["headline"], url: article["links"]["web"]["href"], user_id: 8, source_id: 3, avatar: "espn_logo.jpg")
      post.save
    end
  end
end
