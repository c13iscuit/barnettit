require 'rails_helper'

describe Post do

  describe 'Associations' do

    it 'associates comments with a post' do
      comment = FactoryGirl.create(:comment)
      Post.count.should == 1
      comment.post.title.should == 'I love beer'
    end

    it 'associates upvotes with a post' do
      user = FactoryGirl.create(:user)
      upvote = FactoryGirl.create(:post_upvote, user_id: user.id)
      Post.count.should == 1
      Post.find(upvote.upvotable_id).title.should == 'I love beer'
    end

    it 'associates post with a user' do
      post = FactoryGirl.create(:post)
      post.user.username.should == 'cbtest'
    end
  end

  it 'creates a new full entry' do
    FactoryGirl.create(:post).should be_valid
  end

  it 'requires title' do
    post = FactoryGirl.build(:post, title: nil)
    expect(!post.valid?)
  end

  it 'requires description' do
    post = FactoryGirl.build(:post, description: nil)
    expect(!post.valid?)
  end

  it 'requires user_id' do
    post = FactoryGirl.build(:post, user_id: nil)
    expect(!post.valid?)
  end
end
