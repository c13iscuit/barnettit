FactoryGirl.define do
  factory :comment do
    description 'This post wasnt very helpful'
    post
    user
  end
end
