require 'rails_helper'

feature 'user can vote on comments', %Q{
  As a user I want to upvote comments that I like
  As a user I want to downvote comments that I dont like
} do

  scenario 'user can upvote a comment' do
    comment = FactoryGirl.create(:comment)

    visit "/auth/twitter"
    visit "/posts/#{comment.post.id}"

    click_on "Upvote"

    expect(page).to have_content "votes: 1"
    expect(page).to have_content "Successfully voted!"
    expect(comment.score).to eq(1)
  end

  scenario 'user can upvote a comment only once' do
    comment = FactoryGirl.create(:comment)

    visit "/auth/twitter"
    visit "/posts/#{comment.post.id}"

    click_on "Upvote"
    click_on "Upvote"

    expect(page).to have_content "votes: 1"
    expect(comment.score).to eq(1)
  end

  scenario 'user can downvote a comment' do
    comment = FactoryGirl.create(:comment)

    visit "/auth/twitter"
    visit "/posts/#{comment.post.id}"

    click_on "Downvote"

    expect(page).to have_content "votes: -1"
    expect(page).to have_content "Successfully voted!"
    expect(comment.score).to eq(-1)
  end

  scenario 'user can downvote a comment only once' do
    comment = FactoryGirl.create(:comment)

    visit "/auth/twitter"
    visit "/posts/#{comment.post.id}"

    click_on "Downvote"
    click_on "Downvote"

    expect(page).to have_content "votes: -1"
    expect(comment.score).to eq(-1)
  end
end
