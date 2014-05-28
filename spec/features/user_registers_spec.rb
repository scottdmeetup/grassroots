require 'spec_helper'

feature 'User registers' do
  scenario "with valid input" do
    visit new_user_path
    fill_in "Email", with: "john@example.com"
    fill_in "Password", with: "password"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Smith"
    choose('user_user_group_nonprofit', visible: false)
    click_on('Create')
    expect(page).to have_text("John Smith")
  end

  scenario "with invalid input" do
    visit new_user_path
    fill_in "Email", with: "john@example.com"
    fill_in "Password", with: "password"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Smith"
    click_on('Create')
    expect(page).to have_text("Please try again.")
  end
end
