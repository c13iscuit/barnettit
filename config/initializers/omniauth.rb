Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['App_ID'], ENV['App_Secret']
  provider :twitter, ENV['TWITTER_APP_ID'], ENV['TWITTER_APP_SECRET']
end
