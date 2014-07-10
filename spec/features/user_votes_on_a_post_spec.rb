require 'rails_helper'

feature 'user can vote on posts', %Q{
  As a user I want to upvote posts that I like
  As a user I want to downvote posts that I dont like
} do

  scenario 'user can upvote a post' do
    post = FactoryGirl.create(:post)

    visit "/auth/twitter"

    click_on "Upvote"

    expect(page).to have_content "votes: 1"
    expect(page).to have_content "Successfully voted!"
    expect(post.score).to eq(1)
  end

  scenario 'user can upvote a post only once' do
    post = FactoryGirl.create(:post)

    visit "/auth/twitter"

    click_on "Upvote"
    click_on "Upvote"

    expect(page).to have_content "votes: 1"
    expect(post.score).to eq(1)
  end

  scenario 'user can downvote a post' do
    post = FactoryGirl.create(:post)

    visit "/auth/twitter"

    click_on "Downvote"

    expect(page).to have_content "votes: -1"
    expect(page).to have_content "Successfully voted!"
    expect(post.score).to eq(-1)
  end

  scenario 'user can downvote a post only once' do
    post = FactoryGirl.create(:post)

    visit "/auth/twitter"

    click_on "Downvote"
    click_on "Downvote"

    expect(page).to have_content "votes: -1"
    expect(post.score).to eq(-1)
  end
end
