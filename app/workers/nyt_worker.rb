class NytWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    hourly(4)
  end

  def perform
    uri = URI("http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/1.json?api-key=#{ENV["NYT"]}")
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)
    top = result["results"].take(2)
    top.each do |article|
      post = Post.new(title: article["title"], url: article["url"], user_id: 8)
      post.save
    end
  end
end
