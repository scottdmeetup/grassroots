require 'spec_helper'

feature "Administrator interacts with various applications, contracts and messages in his/her inbox queue" do
  let(:huggey_bear) {Fabricate(:organization, name: "Huggey Bear Land", cause: "Animal Rights", ruling_year: 1998, 
   mission_statement: "We want to give everyone a huggey bear in their sad times", guidestar_membership: nil, 
   ein: "192512653-6", street1: "2998 Hansen Heights", street2: nil, city: "New York", 
   state_id: 0, zip: "28200-1366", ntee_major_category_id: 0, funding_method: nil, user_id: nil,
   budget: "$22,000,000.00", contact_number: "555-555-5555", contact_email: "test@example.com",
   goal: "We want 1 out of every 5 Americans to have a huggey bear.")}

  let(:alice) {Fabricate(:user, organization_id: 1, first_name: "Alice", last_name: "Smith", email: "alice@huggey_bear.org", 
  interests: "Animal Rights", skills: "Grant Writing", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: true, 
  organization_staff: nil, volunteer: nil, position: "Executive Director", password: "password", user_group: "nonprofit")}

  let(:bob) {Fabricate(:user, first_name: "Bob", last_name: "Seltzer", email: "jacob@example.org", 
  interests: "Web Development", skills: "ROR", street1: nil, street2: nil, 
  city: "New York", state_id: "NY", phone_number: nil, zip: nil, organization_administrator: nil, 
  organization_staff: nil, volunteer: true, password: "password", user_group: "volunteer")}

  let(:cat) {Fabricate(:user, first_name: "Cat", user_group: "volunteer")}
  let(:dan) {Fabricate(:user, first_name: "Dan", user_group: "volunteer")}

  let(:word_press) {Fabricate(:project, title: "Need WordPress Site", description: "I want a nice looking WordPress site for my nonprofit", 
  skills: "web development", causes: "animals", deadline: Date.today + 1.month, 
  user_id: alice.id, organization_id: huggey_bear.id, estimated_hours: 22, state: "open")}

  let(:logo) {Fabricate(:project, title: "need a logo", user_id: alice.id, 
  organization_id: huggey_bear.id, state: "open")  }


  before do
    huggey_bear.update_columns(user_id: alice.id)
  end

  scenario "Administrator receives three volunteer applications on one project
   and acceptes one of them with the effect that the button to accept
    the other rejected applications associated with the other conversations disappears" do
    
    word_press
    bob
    cat
    dan
    alice
    
    volunteer_applies_to_word_press_project_and_signs_out(bob)
    volunteer_applies_to_word_press_project_and_signs_out(cat)
    volunteer_applies_to_word_press_project_and_signs_out(dan)
    administrator_contracts_volunteer(alice)

  end

  scenario "Administrator received two applications on one project, accepts one of them, and
   receives another application on another project. The administrator sees two buttons: 
   one for dropping the project in production and the other for accepting a solicitation
    from a volunteer. The administrator accepts the application and signs out. The contracted volunteer submits 
    work and then signs out. the administrator signs in and sees a button to 
    accept the submitted work. There is still a button to drop the other project that is still in
    production. " do
=begin    
    word_press
    bob
    cat
    dan
    alice

    volunteer_applies_to_word_press_project_and_signs_out(bob)
    volunteer_applies_to_word_press_project_and_signs_out(cat)
    administrator_contracts_volunteer(alice)
    volunteer_applies_to_logo_project_and_signs_out(dan)

    administrator_contracts_volunteer(alice)
=end
  end

  scenario "" do
   
  end

private

  def volunteer_applies_to_word_press_project_and_signs_out(user)
    user_signs_in(user)
    expect(page).to have_content("You are logged in!")
    visit projects_path
    
    expect(page).to have_content("Need WordPress Site")
    click_on('Join Project')
    fill_in "private_message[body]", with: "I'd like to join this project"
    
    click_on('Create')
    sign_out       
  end

  def volunteer_applies_to_logo_project_and_signs_out(user)
    user_signs_in(user)
    expect(page).to have_content("You are logged in!")
    visit projects_path
    
    expect(page).to have_content("need a logo")
    click_on('Join Project')
    fill_in "private_message[body]", with: "I'd like to join this project"
    
    click_on('Create')
    sign_out
  end

  def administrator_contracts_volunteer(user)
    user_signs_in(user)
    visit organization_path(user.organization.id)
    expect(page).to have_text("Available Projects 1")
    visit conversations_path
    page.find(:xpath, "//a[@href='/contracts?conversation_id=#{Conversation.first.id}&volunteer_application_id=#{VolunteerApplication.first.id}']").click
    fill_in "private_message[body]", with: "I have accepted your participation"
    click_on('Send')
    visit conversations_path
    expect(page).to have_text("Drop Contract")
    page.should have_no_content("Volunteer Application")
    visit organization_path(user.organization.id)
    expect(page).to have_text("Projects in Production 1")
    sign_out
  end
end