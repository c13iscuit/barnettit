require 'rails_helper'

describe Comment do

  describe 'Associations' do

    it 'associates comments with a post' do
      comment = FactoryGirl.create(:comment)
      Post.count.should == 1
      comment.post.title.should == 'I love beer'
    end

    it 'associates upvotes with a comment' do
      user = FactoryGirl.create(:user)
      upvote = FactoryGirl.create(:comment_upvote, user_id: user.id)
      Comment.count.should == 1
      Comment.find(upvote.upvotable_id).description.should == 'This post wasnt very helpful'
    end

    it 'associates comment with a user' do
      comment = FactoryGirl.create(:comment)
      comment.user.username.should == 'cbtest'
    end
  end

  it 'creates a new full entry' do
    FactoryGirl.create(:comment).should be_valid
  end

  it 'requires description' do
    comment = FactoryGirl.build(:comment, description: nil)
    expect(!comment.valid?)
  end

  it 'requires user_id' do
    comment = FactoryGirl.build(:comment, user_id: nil)
    expect(!comment.valid?)
  end
end
