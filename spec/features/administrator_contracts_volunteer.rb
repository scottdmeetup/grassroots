require 'spec_helper'

feature  "Volunteer successfully joins a project"do
  scenario "Volunteer requests to join a nonprofit's project and Administrator accepts" do
    huggey_bear = Fabricate(:organization, name: "Huggey Bear Land", cause: "Animal Rights", ruling_year: 1998, 
      mission_statement: "We want to give everyone a huggey bear in their sad times", guidestar_membership: nil, 
      ein: "192512653-6", street1: "2998 Hansen Heights", street2: nil, city: "New York", 
      state_id: 0, zip: "28200-1366", ntee_major_category_id: 0, funding_method: nil, user_id: nil,
      budget: "$22,000,000.00", contact_number: "555-555-5555", contact_email: "test@example.com",
      goal: "We want 1 out of every 5 Americans to have a huggey bear.")

    alice = Fabricate(:user, organization_id: 1, first_name: "Alice", last_name: "Smith", email: "alice@huggey_bear.org", 
      interests: "Animal Rights", skills: "Grant Writing", street1: nil, street2: nil, 
      city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: true, 
      organization_staff: nil, volunteer: nil, position: "Executive Director", password: "password", user_group: "nonprofit")
    huggey_bear.update_columns(user_id: 1)
    bob = Fabricate(:user, first_name: "Bob", last_name: "Seltzer", email: "jacob@example.org", 
      interests: "Web Development", skills: "ROR", street1: nil, street2: nil, 
      city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: nil, 
      organization_staff: nil, volunteer: true, password: "password", user_group: "volunteer")
    word_press = Fabricate(:project, title: "Need WordPress Site", description: "I want a nice looking WordPress site for my nonprofit", 
      skills: "web development", causes: "animals", deadline: Date.today + 1.month, user_id: 1, organization_id: 1, estimated_hours: 22, state: "open")
    alice.projects << word_press
    
    user_signs_in(bob)
    expect(page).to have_content("You are logged in!")
    volunteer_joins_project
    sign_out

    user_signs_in(alice)
    project_administrator_contracts_volunteer_and_accepts_application
    sign_out

    user_signs_in(bob)
    volunteer_sees_project_in_production
  end

  def volunteer_joins_project
    visit projects_path
    expect(page).to have_content("Need WordPress Site")
    click_on('Join Project')
    fill_in "private_message[body]", with: "I'd like to join this project"
    click_on('Create')   
  end

  def project_administrator_contracts_volunteer_and_accepts_application
    visit conversations_path
    click_on('Accept')
    fill_in "private_message[body]", with: "I have accepted your participation"
    visit conversations_path
    expect(page).to have_text("Drop Volunteer")
    visit organization_path(huggey_bear.id)
    expect(page).to have_text("In Production 1")
  end

  def volunteer_sees_project_in_production
    expect(page).to have_text("In Production 1")
    visit conversations_path
    expect(page).to have_text("Drop Project")
  end
end