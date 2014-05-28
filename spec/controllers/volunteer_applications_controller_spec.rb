require 'spec_helper'

describe VolunteerApplicationsController, :type => :controller do
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
  describe "POST create" do
    let(:huggey_bear) {Fabricate(:organization)}
    let(:alice) {Fabricate(:organization_administrator, user_group: "nonprofit")}
    let(:bob) {Fabricate(:user, user_group: "volunteer")}
    let(:word_press) {Fabricate(:project)}
    
    before do
      set_current_user(bob)
      huggey_bear.update_columns(user_id: alice.id)
    end

    context "with valid input" do
      it "renders the current user's inbox" do

        post :create, project_id: word_press.id, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"
        expect(response).to redirect_to(conversations_path)
      end
     
      it "creates a volunteer application" do
        post :create, project_id: word_press.id, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"
        expect(VolunteerApplication.count).to eq(1)
      end
     
      it "associates the application with the volunteer" do
        post :create, project_id: word_press.id, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"
        expect(VolunteerApplication.first.user).to eq(bob)
      end
     
      it "associates the application with the project" do
        post :create, project_id: word_press.id, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"
        expect(VolunteerApplication.first.project).to eq(word_press)
      end
      
      it "associates the application with a conversation" do  
        post :create, project_id: word_press.id, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"
        expect(Conversation.first.volunteer_application_id).to eq(1)
      end
      it "sends the application to the project administrator" do
        post :create, project_id: word_press.id, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"
        expect(alice.conversations.first).to eq(Conversation.first)
      end

      it "associates the project with the applicant" do
        post :create, project_id: word_press.id, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project"
        expect(bob.open_project_applications).to eq([word_press])
      end
      
      #it "creates a conversation id with a unique volunteer application foreign key"
      #it "makes the recipient of the message see a conversation, which has a volunteer_application_id" 
    end
  end
=begin
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
#conversation1 = double(:volunteer_app, id: 1, update_columns: 1)
#message1 = double(:volunteer_app, update_columns: conversation1.id, recipient_id: 2)
#Conversation.should_receive(:create).and_return(conversation1)
#PrivateMessage.should_receive(:create).and_return(message1)
