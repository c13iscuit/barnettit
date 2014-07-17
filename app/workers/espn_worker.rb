class EspnWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    hourly(6)
  end

  def perform
    uri = URI("http://api.espn.com/v1/sports/news/headlines/top?apikey=#{ENV["ESPN_KEY"]}")
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)
    top = result["headlines"].take(2)
    top.each do |article|
      post = Post.new(title: article["headline"], url: article["links"]["web"]["href"], user_id: 8)
      post.save
    end
  end
end
