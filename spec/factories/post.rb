FactoryGirl.define do
  factory :post do
    title 'I love beer'
    description 'There are a ton of good beer bars in Boston!'
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/support/images/sample.png')) }
    user
  end
end
