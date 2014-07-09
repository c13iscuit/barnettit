require 'rails_helper'
  feature 'user can downvote posts and comments', %Q{
  # -As a user I want to downvote posts I don't like
  # -As a user I want to downvote comments I don't like
} do

  scenario '-user can downvote a post' do

    user = FactoryGirl.create(:user)
    post = FactoryGirl.create(:post)
    upvote = FactoryGirl.create(:upvote, upvotable_id: post.id, upvotable_type: "Post", user_id: user.id)

    #sign in the user!

    visit "/"

    click_on "Downvote"

    expect(page).to have_content "votes: 1"
    expect post.upvote.count.to eq(1)
  end

  scenario '-user can downvote a comment' do

    user = FactoryGirl.create(:user)
    comment = FactoryGirl.create(:comment)

    #sign in the user!
    visit "posts/#{comment.post.id}"

    click_on "Downvote"

    expect(page).to have_content "votes: -1"
    expect comment.upvote.count.to eq(-1)
  end

end
