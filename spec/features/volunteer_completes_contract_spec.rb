require 'spec_helper'

feature "Either volunteer or project administrator ends contract" do
  scenario "volunteer completes the project" do
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
    bob.projects << word_press
    conversation = Fabricate(:conversation)
    conversation1 = Fabricate(:conversation)
    word_press.update_columns(state: "in production")
    message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Project Completed: word press website", body: "I finished this project", project_id: word_press.id)

    user_signs_in(bob)
    volunteer_requests_to_complete_contracted_work(bob)
    sign_out

    user_signs_in(alice)
    project_administrator_confirms_contracts_completion(alice)
    sign_out

    user_signs_in(bob)
    expect(page).to have_text("Completed 1")
  end

  scenario "volunteer drops the project" do
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
    bob.projects << word_press
    conversation = Fabricate(:conversation)
    conversation1 = Fabricate(:conversation)
    word_press.update_columns(state: "in production")
    message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Project Request: word press website", body: "I want to join this project", project_id: word_press.id)
    message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, conversation_id: conversation1.id, subject: "Project Request: word press website", body: "I approve you to do this work", project_id: word_press.id)

    user_signs_in(bob)
    volunteer_drops_project(bob)
    sign_out

    user_signs_in(alice)
    visit conversations_path
    expect(page).to have_content("Bob Seltzer has been dropped on this project. This is an automated message.")
    sign_out
  end

  scenario "project administrator drops volunteer" do
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
    bob.projects << word_press
    conversation = Fabricate(:conversation)
    conversation1 = Fabricate(:conversation)
    word_press.update_columns(state: "in production")
    message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Project Request: word press website", body: "I want to join this project", project_id: word_press.id)
    message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, conversation_id: conversation1.id, subject: "Project Request: word press website", body: "I approve you to do this work", project_id: word_press.id)

    user_signs_in(alice)
    project_administrator_drops_project(alice)
    sign_out

    user_signs_in(bob)
    volunteer_sees_contract_has_been_dropped
    sign_out
  end

  def project_administrator_drops_project(admin)
    expect(page).to have_content("In Production 1")
    visit conversations_path
    click_on('Drop Volunteer')
    visit user_path(admin.id)
    expect(page).to have_content("Open 1")
    expect(page).to have_content("In Production 0")
    expect(page).to have_content("Completion Request 0")
    expect(page).to have_content("Completed 0")
    expect(page).to have_content("Unfinished 0")
  end

  def volunteer_sees_contract_has_been_dropped
    expect(page).to have_content("Open 0")
    expect(page).to have_content("In Production 0")
    expect(page).to have_content("Completion Request 0")
    expect(page).to have_content("Completed 0")
    expect(page).to have_content("Unfinished 0")
    visit conversations_path
    expect(page).to have_content("Bob Seltzer has been dropped on this project. This is an automated message.")
  end

  def volunteer_drops_project(volunteer)
    visit conversations_path
    click_on('Drop Project')
    visit user_path(volunteer.id)
    expect(page).to have_content("Open 0")
    expect(page).to have_content("In Production 0")
    expect(page).to have_content("Completion Request 0")
    expect(page).to have_content("Completed 0")
    expect(page).to have_content("Unfinished 0")
  end

  def volunteer_requests_to_complete_contracted_work(volunteer)
    click_on('In Production')
    click_on('Project Complete')
    fill_in "private_message[body]", with: "This is done"
    click_on('Create')
    visit user_path(volunteer.id)
    expect(page).to have_text("Completion Request 1")
  end

  def project_administrator_confirms_contracts_completion(administrator)
    expect(page).to have_content("Completion Request 1")
    visit conversations_path
    click_on('Completed')
    fill_in "private_message[body]", with: "Great work."
    click_on('Send')
    visit user_path(administrator.id)
    expect(page).to have_text("Completed 1")
  end
end