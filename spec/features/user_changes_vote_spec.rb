require 'rails_helper'

feature 'user can change their vote on comments and posts', %Q{
  As a user I want to change my vote on a comment
  As a user I want to change my vote on a post
} do

  scenario 'user can change their vote on a post' do
    post = FactoryGirl.create(:post)
    source = FactoryGirl.create(:source, id: 8)
    sub = FactoryGirl.create(:subscription, user_id: post.user.id)

    visit "/auth/twitter"

    click_on "downvote"

    expect(page).to have_content "votes: -1"
    expect(page).to have_content "Successfully voted!"
    expect(post.score_count).to eq(-1)

    click_on "upvote"

    expect(page).to have_content "votes: 1"
    expect(page).to have_content "Successfully voted!"
    expect(post.score_count).to eq(1)
  end

  scenario 'user can change their vote on a comment' do
    comment = FactoryGirl.create(:comment)
    source = FactoryGirl.create(:source, id: 8)
    sub = FactoryGirl.create(:subscription, user_id: comment.user.id)

    visit "/auth/twitter"
    visit "posts/#{comment.post.id}"

    click_on "downvote"

    expect(page).to have_content "votes: -1"
    expect(page).to have_content "Successfully voted!"
    expect(comment.score_count).to eq(-1)

    click_on "upvote"

    expect(page).to have_content "votes: 1"
    expect(page).to have_content "Successfully voted!"
    expect(comment.score_count).to eq(1)
  end
end
