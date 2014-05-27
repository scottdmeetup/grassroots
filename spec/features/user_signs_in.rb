require 'spec_helper'

feature 'User signs in' do 
  scenario "with existing user" do
    john_doe = Fabricate(:user, user_group: "nonprofit")
    user_signs_in(john_doe)
    expect(page).to have_content("You are logged in!")
  end
end