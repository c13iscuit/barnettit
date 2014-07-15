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
    top = result["results"].take(3)
    top.each do |article|
      Post.create(title: article["title"], url: article["url"], user_id: 8)
    end
  end
end
