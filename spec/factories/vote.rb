FactoryGirl.define do
  factory :vote do
    value 1
    user

    trait :post_vote do
      votable_type 'Post'
      association :votable, factory: :post
    end

    trait :comment_vote do
      votable_type 'Comment'
      association :votable, factory: :comment
    end

    factory :post_vote, traits: [:post_vote]
    factory :comment_vote, traits: [:comment_vote]
  end
end
