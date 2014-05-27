require 'spec_helper'



feature "Administrator creates a project"
feature "Volunteer searches for projects to work on"
feature "Volunteer solicits volunteer's skills to engage a nonprofit through its project " do
  scenario "Volunteer successfully joins a project" do
=begin
    A volunteer signs in
    a volunteer clicks on the project index
    expect page to have thumbnails
    a volunteer clicks on the web development filter
    a volunteer clicks on the image to see the project details
    expect page to have description
    a volunteer clicks on the button, join project
    a volunteer sends a message to the administrator
    the volunteer's profile page loads
    expect page to have project on dashboard with a open state
    volunteer signs out

    administrator signs in
    expect page to have project with a plus sign on it
    administrator clicks on inbox
    expect page to have a message
    administrator clicks on message
    expect page to have body
    administrator clicks on inbox
    administrator clicks on accept volunteer 
    reply to page loads
    administrators writes a message 
    inbox loads
    expect page to have drop volunteer button
    administrator clicks on profile button
    expect page to have project in ,in production state
    administrator signs out
=end
  end
  scenario "Volunteer unsuccessfully joins a project"
end
feature "Administrator contracts a volunteer" do
  scenario "administrator accepts a volunteer's request to join his/her project" do
=begin
    administrator receives requests to join a project
    administrator accepts one of them
    write a message page loads
    administrator writes a message to contracted volunteer
    inbox loads and the administrator sees the ability to drop the volunteer
    administrator clicks on the profile button
    expect page to have a project in production
    administrator signs out

    volunteer signs in
    expect volunteer's profile page to have a project in production 
    volunteer visits inbox
    volunteers sees the message with the button to drop the project
    volunteer clicks on the message
    volunteer writes to administrator with his email and phone number
    volunteer signs out
=end
  end
end
feature "Volunteer ends contract with nonprofit" do
  scenario "volunteer completes the project"
  scenario "volunteer does not complete the project"
  scenario "volunteer drops the project"
end

feature "Administrator ends contract with volunteer" do
  scenario "Administrator confirms volunteer's completion of the project"
  scenario "Administrator drops the volunteer"
  scenario "Administrator terminates the project while project is in production"
end


feature "Administrator deletes project" do
  scenario "Administrator removes project"
  scenario "Administrator receives reqeusts to join a project that he/she will cancel the project"
  scenario "Administrator removes a project with a contracted volunteer"
end
feature "Volunteer drops a project"
feature "User messages other user"
