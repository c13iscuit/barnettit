FactoryGirl.define do
  factory :vote do
    value 1

    trait :post_vote do
      votable_type 'Post'
      association :votable, factory: :post
      association :user, factory: :user
    end

    trait :comment_vote do
      votable_type 'Comment'
      association :votable, factory: :comment
      association :user, factory: :user
    end

    factory :post_vote, traits: [:post_vote]
    factory :comment_vote, traits: [:comment_vote]
  end
end
