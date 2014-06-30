require 'rails_helper'

describe UpvotePair do
  describe "Associations" do
    it "associates upvote_pair with a user" do
      user = FactoryGirl.create(:user)
      upvote = FactoryGirl.create(:post_upvote, user_id: user.id)
      upvote.upvote_pairs.first.user.username.should == "cbtest"
    end

    it "associates upvote_pair with an upvote" do
      user = FactoryGirl.create(:user)
      upvote = FactoryGirl.create(:post_upvote, user_id: user.id)
      expect(upvote.upvote_pairs).to be_valid
    end

  end
end

