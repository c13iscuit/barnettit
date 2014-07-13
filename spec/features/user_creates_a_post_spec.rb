require 'rails_helper'

feature 'user can add a post to barnettit', %Q{
  As a user I want to add a post for others to see
} do

  scenario 'user can add a text post' do
    user = FactoryGirl.create(:user)

    visit "/auth/twitter"

    click_on "Create a post!"

    click_on "text"
    fill_in "Title", with: "super duper test post"
    fill_in "Description", with: "description of super duper test post"
    click_on "Create Post"

    expect(page).to have_content "super duper test post"
    expect(page).to have_content "description of"
    expect(post.count).to eq(1)
  end

  scenario 'user can add a link post' do
    user = FactoryGirl.create(:user)

    visit "/auth/twitter"

    click_on "Create a post!"

    click_on "link"
    fill_in "Title", with: "super duper link test post"
    fill_in "Link", with: "http://en.wikipedia.org/wiki/Warhammer_40,000:_Dawn_of_War"
    click_on "Create Post"

    expect(page).to have_content "super duper link test post"
    expect(post.count).to eq(1)
  end

  scenario 'user can upload an image post' do
    user = FactoryGirl.create(:user)

    visit "/auth/twitter"

    click_on "Create a post!"

    click_on "text"
    fill_in "Title", with: "super duper image test post"
    #select image to upload
    click_on "Create Post"

    expect(page).to have_content "super duper image test post"
    #expect to find image
    expect(post.count).to eq(1)
  end
end
