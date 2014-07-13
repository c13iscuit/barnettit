CarrierWave.configure do |config|
  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  else
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWSAccessKeyId'],
      aws_secret_access_key: ENV['AWSSecretKey']
    }
    config.fog_directory = ENV['S3_BUCKET']
  end
end
