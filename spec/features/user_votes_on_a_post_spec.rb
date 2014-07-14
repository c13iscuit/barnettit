require 'rails_helper'

feature 'user can vote on posts', %Q{
  As a user I want to upvote posts that I like
  As a user I want to downvote posts that I dont like
} do

  scenario 'user can upvote a post' do
    post = FactoryGirl.create(:post)

    visit "/auth/twitter"

    click_on "upvote"

    expect(page).to have_content "votes: 1"
    expect(page).to have_content "Successfully voted!"
    expect(post.score_count).to eq(1)
  end

  scenario 'user can upvote a post only once' do
    post = FactoryGirl.create(:post)

    visit "/auth/twitter"

    click_on "upvote"
    click_on "upvote"

    expect(page).to have_content "votes: 1"
    expect(post.score_count).to eq(1)
  end

  scenario 'user can downvote a post' do
    post = FactoryGirl.create(:post)

    visit "/auth/twitter"

    click_on "downvote"

    expect(page).to have_content "votes: -1"
    expect(page).to have_content "Successfully voted!"
    expect(post.score_count).to eq(-1)
  end

  scenario 'user can downvote a post only once' do
    post = FactoryGirl.create(:post)

    visit "/auth/twitter"

    click_on "downvote"
    click_on "downvote"

    expect(page).to have_content "votes: -1"
    expect(post.score_count).to eq(-1)
  end
end
