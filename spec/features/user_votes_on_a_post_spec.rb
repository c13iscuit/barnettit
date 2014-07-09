require 'rails_helper'

feature 'user can vote on posts', %Q{
  As a user I want to downvote posts I don't like
  As a user I want to downvote comments I don't like
} do

  scenario '-user can upvote a post' do
    post = FactoryGirl.create(:post)

    visit "/auth/twitter"

    click_on "Upvote"

    expect(page).to have_content "votes: 1"
    expect(post.score).to eq(1)
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
