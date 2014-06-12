=begin
require 'spec_helper'

feature "User creates an organization" do
  scenario "user registers as a nonprofit and while filling out his/her profile he is routed to create an orgnaization" do
    visit new_user_path
    fill_in "Email", with: "john@example.com"
    fill_in "Password", with: "password"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Smith"
    choose('user_user_group_nonprofit', visible: false)
    click_on("Create")
    expect(page).to have_text("John Smith")
    expect(page).to have_text("30%")
    click_on("Edit Your Profile")

    fill_in "Position", with: "john@example.com"
    fill_in "Skills", with: "password"
    fill_in "Interests", with: "John"
    fill_in "Last Name", with: "Smith"    

    
  end
end
=end