require 'rails_helper'

feature 'user can change their vote on comments and posts', %Q{
  As a user I want to change my vote on a comment
  As a user I want to change my vote on a post
} do

  scenario 'user can change their vote on a post' do
    post = FactoryGirl.create(:post)

    visit "/auth/twitter"

    click_on "Downvote"

    expect(page).to have_content "votes: -1"
    expect(page).to have_content "Successfully voted!"
    expect(post.score).to eq(-1)

    click_on "Upvote"

    expect(page).to have_content "votes: 1"
    expect(page).to have_content "Successfully voted!"
    expect(post.score).to eq(1)
  end

  scenario 'user can change their vote on a comment' do
    comment = FactoryGirl.create(:comment)

    visit "/auth/twitter"
    visit "posts/#{comment.post.id}"

    click_on "Downvote"

    expect(page).to have_content "votes: -1"
    expect(page).to have_content "Successfully voted!"
    expect(comment.score).to eq(-1)

    click_on "Upvote"

    expect(page).to have_content "votes: 1"
    expect(page).to have_content "Successfully voted!"
    expect(comment.score).to eq(1)
  end
end
