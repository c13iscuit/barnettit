FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "cbtest#{n}" }
    sequence(:uid) { |n| n }
    provider "twitter"
  end
end
