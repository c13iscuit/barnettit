CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWSAccessKeyId'],
    aws_secret_access_key: ENV['AWSSecretKey']
  }
  config.fog_directory  = ENV['S3_BUCKET']
end
