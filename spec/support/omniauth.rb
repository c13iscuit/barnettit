# omniauth.rb
RSpec.configure do |config|
  OmniAuth.config.test_mode = true
  omniauth_hash = { uid: '12345', info: { name: 'test_user' } }
  OmniAuth.config.add_mock(:twitter, omniauth_hash)
end
