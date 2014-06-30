FactoryGirl.define do
  factory :upvote do

    trait :post_upvote do
      upvotable_type 'Post'
      association :upvotable, factory: :post
      association :user_id, factory: :user
    end

    trait :comment_upvote do
      upvotable_type 'Comment'
      association :upvotable, factory: :comment
      association :user_id, factory: :user
    end

    factory :post_upvote, traits: [:post_upvote]
    factory :comment_upvote, traits: [:comment_upvote]
  end
end

