=begin
require 'spec_helper'


feature 'User has a conversation with messages with other user' do 
  scenario "A user messages another user and that user replies to the message" do
    alice = Fabricate(:user, user_group: "nonprofit")
    bob = Fabricate(:user, user_group: "volunteer")

    user_signs_in(alice)
    visit users_path

    find(:xpath, "//input[@id='web_dev_check_box]'[@value='web development']").set(true)
    #find(:css, "web_dev_check_box[@value='web development']").set(true)
    #click_on('Web Development')
    #click_on('Web Development')
    page.find(:xpath, "//input[@id='/project-filter-submit']").click
    
    fill_in "private_message[subject]", with: "question about your skills"
    fill_in "private_message[body]", with: "When did you start programming?"
    click_on('Create')
    sign_out

    user_signs_in(bob)
    visit conversations_path
    
    click_on("question about your skills")
    fill_in "private_message[body]", with: "I started 9 months ago. Why do you ask?"
    click_on('Send')
    sign_out

    user_signs_in(alice)
    visit conversations_path
    click_on("question about your skills")
    expect(page).to have_content("I started 9 months ago. Why do you ask?")
    fill_in "private_message[body]", with: "I'm impressed with how much you have learned."
    click_on('Send')
    sign_out

    user_signs_in(bob)
    visit conversations_path
    expect(page).to have_content("I'm impressed with how much you have learned.")

  end
end
=end