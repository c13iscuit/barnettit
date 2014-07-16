class WsjWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    hourly(4)
  end

  def perform
    uri = URI("http://betawebapi.dowjones.com/fintech/articles/api/v1/source/424/?count=3")
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)
    top = result["Headlines"].take(3)
    top.each do |article|
      post = Post.new(title: article["Headline"], url: article["ExternalLink"], user_id: 8)
      post.save
    end
  end
end
