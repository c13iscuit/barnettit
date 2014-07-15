class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :params_with_uid

  def params_with_uid(object)
    object.merge!(user_id: session[:user_id])
  end

  def fetch_NYT
    uri = URI("http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/1.json?api-key=#{ENV["NYT"]}")
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)
    top = result["results"].take(3)
    top.each do |article|
      Post.create(title: article["title"], url: article["url"], user_id: 8)
    end
  end

  def fetch_WSJ
    uri = URI("http://betawebapi.dowjones.com/fintech/articles/api/v1/source/424/?count=3")
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)
    top = result["Headlines"].take(3)
    top.each do |article|
      Post.create(title: article["Headline"], url: article["ExternalLink"], user_id: 8)
    end
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authorize_user
    unless current_user
      redirect_to :back, notice: "You must be logged in to do that!"
    end
  end
end
