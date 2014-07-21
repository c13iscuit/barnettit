require 'rails_helper'

feature 'user can add a post to barnettit', %Q{
  As a user I want to add a post for others to see
} do

  scenario 'user can add a text post' do
    user = FactoryGirl.create(:user)
    source = FactoryGirl.create(:source, id: 8)
    sub = FactoryGirl.create(:subscription, user_id: user.id)

    visit "/auth/twitter"

    click_on "Add a post"

    click_on "text"
    fill_in "text-title", with: "super duper test post"
    fill_in "text-description", with: "description of super duper test post"
    click_on "text-submit-btn"

    expect(page).to have_content "super duper test post"

    click_on "super duper test post"

    expect(page).to have_content "description of"
    expect(Post.count).to eq(1)
  end

  scenario 'user can add a link post' do
    user = FactoryGirl.create(:user)
    source = FactoryGirl.create(:source, id: 8)
    sub = FactoryGirl.create(:subscription, user_id: user.id)

    visit "/auth/twitter"

    click_on "Add a post"

    click_on "link"
    fill_in "link-title", with: "super duper link test post"
    fill_in "Url", with: "http://en.wikipedia.org/wiki/Warhammer_40,000:_Dawn_of_War"
    click_on "link-submit-btn"

    expect(page).to have_content "super duper link test post"
    expect(Post.count).to eq(1)
  end

  scenario 'user can upload an image post' do
    user = FactoryGirl.create(:user)
    source = FactoryGirl.create(:source, id: 8)
    sub = FactoryGirl.create(:subscription, user_id: user.id)

    visit "/auth/twitter"

    click_on "Add a post"

    click_on "photo"
    fill_in "photo-title", with: "super duper image test post"
    page.attach_file("Image", "#{Rails.root}/app/assets/images/LA_logo.png")
    click_on "photo-submit-btn"

    expect(page).to have_content "super duper image test post"
    expect(Post.first.image).to be_truthy
    expect(Post.count).to eq(1)
  end
end
