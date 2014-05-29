require 'spec_helper'

describe VolunteerApplicationsController, :type => :controller do


=begin
  describe "POST create" do
    let(:huggey_bear) {Fabricate(:organization)}
    let(:alice) {Fabricate(:organization_administrator, user_group: "nonprofit")}
    let(:bob) {Fabricate(:user, user_group: "volunteer")}
    let(:word_press) {Fabricate(:project)}
    
    before do
      set_current_user(alice)
      huggey_bear.update_columns(user_id: alice.id)
    end

    it "renders the conversation show view" do
      post :create
      expect(response).to redirect_to
    end
    it "creates a contract"

  end

  let(:huggey_bear) {Fabricate(:organization)}
  let(:alice) {Fabricate(:organization_administrator, first_name: "Alice", user_group: "nonprofit")}
  let(:bob) {Fabricate(:user, first_name: "Bob", user_group: "volunteer")}
  let(:cat) {Fabricate(:user, first_name: "Cat", user_group: "volunteer")}
  #let(:word_press) {Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open")}
  #let(:logo) {Fabricate(:project, title: "need a logo", user_id: alice.id, organization_id: amnesty.id, state: "open") }
  
  #let(:application1) {Fabricate(:volunteer_application, user_id: bob.id, project_id: word_press.id)}
  #let(:conversation1) {Fabricate(:conversation, volunteer_application_id: application1.id) }
  #let(:message1) {Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)}
  
  #let(:application2) {Fabricate(:volunteer_application, user_id: cat.id, project_id: logo.id)}
  #let(:conversation2) {Fabricate(:conversation, volunteer_application_id: application2.id)} 
  #let(:message2) {Fabricate(:private_message, recipient_id: cat.id, sender_id: bob.id, conversation_id: conversation2.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: logo.id)}

  #amnesty = Fabricate(:organization, user_id: cat.id)
  
  before do
    set_current_user(bob)
    huggey_bear.update_columns(user_id: alice.id)
  end

  describe "GET index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns the @volunteer_applications" do
      #alice = Fabricate(:organization_administrator, first_name: "Alice", user_group: "nonprofit")
      
      #cat = Fabricate(:organization_administrator, first_name: "Cat", user_group: "volunteer")

      #huggey_bear = Fabricate(:organization, user_id: alice.id)
      set_current_user(bob)
      logo = Fabricate(:project, title: "need a logo", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 

      application1 = VolunteerApplication.create(user_id: bob.id, project_id: word_press.id)
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)
          
      application2 = VolunteerApplication.create(user_id: bob.id, project_id: logo.id)
      conversation2 = Fabricate(:conversation, volunteer_application_id: application2.id) 
      message2 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation2.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: logo.id)

      get :index
      expect(assigns(:open_volunteer_applications)).to match_array([application1, application2])
    end

    it "shows a volunteer all his/her applications" do
      logo = Fabricate(:project, title: "need a logo", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 

      application1 = VolunteerApplication.create(user_id: bob.id, project_id: word_press.id)
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)
          
      application2 = VolunteerApplication.create(user_id: bob.id, project_id: logo.id)
      conversation2 = Fabricate(:conversation, volunteer_application_id: application2.id) 
      message2 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation2.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: logo.id)

      get :index
      expect(bob.volunteers_open_applications).to eq([application1, application2])
    end
    it "shows a project administrator all his/her received applications" do
      huggey_bear = Fabricate(:organization, user_id: alice.id)
      logo = Fabricate(:project, title: "need a logo", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 
      huggey_bear.update_attributes(user_id: alice.id)
      alice.update_attributes(organization_id: huggey_bear.id)
      set_current_user(alice)

      application1 = VolunteerApplication.create(user_id: bob.id, project_id: word_press.id)
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)
          
      application2 = VolunteerApplication.create(user_id: cat.id, project_id: logo.id)
      conversation2 = Fabricate(:conversation, volunteer_application_id: application2.id) 
      message2 = Fabricate(:private_message, recipient_id: alice.id, sender_id: cat.id, conversation_id: conversation2.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: logo.id)

      get :index
      expect(alice.administrators_open_applications).to eq([application1, application2])
    end
  end
=end

=begin
  describe "GET new" do
    let(:huggey_bear) {Fabricate(:organization)}
    let(:alice) {Fabricate(:organization_administrator, user_group: "nonprofit")}
    let(:bob) {Fabricate(:user, user_group: "volunteer")}
    let(:word_press) {Fabricate(:project)}
    
    before do
      set_current_user(bob)
      huggey_bear.update_columns(user_id: alice.id)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
    it "sets the @volunteer_application" do
      get :new
      expect(assigns(:volunteer_application)).to be_instance_of(VolunteerApplication)
    end
    it "sets values for the @private_message" do
      get :new
      expect(assigns(:private_message)).to be_instance_of(PrivateMessage)
    end
  end
  
  describe "GET accept" do
    let(:alice) { Fabricate(:organization_administrator, organization_id: nil, first_name: "Alice", user_group: "nonprofit") }
    let(:bob) { Fabricate(:user, first_name: "Bob", user_group: "volunteer") }
    let(:elena) { Fabricate(:user, first_name: "Elena", user_group: "volunteer") }
    let(:dan) { Fabricate(:user, first_name: "Dan", user_group: "volunteer")}
    let(:huggey_bear) { Fabricate(:organization, user_id: alice.id) }
    let(:word_press) { Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") }
    let(:application1) {Fabricate(:volunteer_application, user_id: bob.id, project_id: word_press.id)}
    let(:application2) {Fabricate(:volunteer_application, user_id: elena.id, project_id: word_press.id)}
    let(:application3) {Fabricate(:volunteer_application, user_id: dan.id, project_id: word_press.id)}

    let(:conversation1) { Fabricate(:conversation, volunteer_application_id: application1.id) }
    let(:conversation2) { Fabricate(:conversation, volunteer_application_id: application2.id) }
    let(:conversation3) { Fabricate(:conversation, volunteer_application_id: application3.id) }
    let(:message1) { Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id) }
    let(:message2) { Fabricate(:private_message, recipient_id: alice.id, sender_id: elena.id, conversation_id: conversation2.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id) }
    let(:message3) { Fabricate(:private_message, recipient_id: alice.id, sender_id: dan.id, conversation_id: conversation3.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id) }

    it "redirects the current user to the conversation so that the user can reply to the freelancer" do
      post :accept, conversation_id: conversation1.id
      expect(response).to redirect_to conversation_path(conversation1.id)
    end

    it "unassociates all unaccepted users who have sent an application" do
      post :accept, conversation_id: conversation1.id
      expect(word_press.contracted_volunteers).not_to eq([alice, bob, elena, dan])
    end

    it "associates only the sender and the current user of the conversation with the project" do
      post :accept, conversation_id: conversation1.id
      expect(word_press.reload.users).to eq([alice, bob])
    end

    it "sets all the private messages' project ids to nil except the one associated with the accepted project" do
      post :accept, conversation_id: conversation1.id

      expect(message1.reload.project_id).to eq(1)
      expect(message2.reload.project_id).to eq(nil)
      expect(message3.reload.project_id).to eq(nil)
    end

    it "sets the project's state from open to in production" do
      post :accept, conversation_id: conversation1.id

      expect(word_press.reload.state).to eq("in production")
    end
  end
=end
end

