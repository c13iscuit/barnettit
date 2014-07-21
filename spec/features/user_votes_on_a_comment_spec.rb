require 'rails_helper'

feature 'user can vote on comments', %Q{
  As a user I want to upvote comments that I like
  As a user I want to downvote comments that I dont like
} do

  scenario 'user can upvote a comment' do
    comment = FactoryGirl.create(:comment)
    source = FactoryGirl.create(:source, id: 8)
    sub = FactoryGirl.create(:subscription, user_id: comment.user.id)


    visit "/auth/twitter"
    visit "/posts/#{comment.post.id}"

    click_on "upvote"

    expect(page).to have_content "votes: 1"
    expect(page).to have_content "Successfully voted!"
    expect(comment.score_count).to eq(1)
  end

  scenario 'user can upvote a comment only once' do
    comment = FactoryGirl.create(:comment)
    source = FactoryGirl.create(:source, id: 8)
    sub = FactoryGirl.create(:subscription, user_id: comment.user.id)

    visit "/auth/twitter"
    visit "/posts/#{comment.post.id}"

    click_on "upvote"
    click_on "upvote"

    expect(page).to have_content "votes: 1"
    expect(comment.score_count).to eq(1)
  end

  scenario 'user can downvote a comment' do
    comment = FactoryGirl.create(:comment)
    source = FactoryGirl.create(:source, id: 8)
    sub = FactoryGirl.create(:subscription, user_id: comment.user.id)

    visit "/auth/twitter"
    visit "/posts/#{comment.post.id}"

    click_on "downvote"

    expect(page).to have_content "votes: -1"
    expect(page).to have_content "Successfully voted!"
    expect(comment.score_count).to eq(-1)
  end

  scenario 'user can downvote a comment only once' do
    comment = FactoryGirl.create(:comment)
    source = FactoryGirl.create(:source, id: 8)
    sub = FactoryGirl.create(:subscription, user_id: comment.user.id)

    visit "/auth/twitter"
    visit "/posts/#{comment.post.id}"

    click_on "downvote"
    click_on "downvote"

    expect(page).to have_content "votes: -1"
    expect(comment.score_count).to eq(-1)
  end
end
