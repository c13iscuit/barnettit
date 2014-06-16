Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 'fb_key', 'fb_secret'
end
