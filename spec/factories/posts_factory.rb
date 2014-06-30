FactoryGirl.define do
  factory :post do
    title 'I love beer'
    description 'There are a ton of good beer bars in Boston!'

    user
  end
end
