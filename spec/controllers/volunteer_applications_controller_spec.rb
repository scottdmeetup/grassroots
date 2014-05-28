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

        #conversation1 = double(:volunteer_app, id: 1, update_columns: 1)
        #message1 = double(:volunteer_app, update_columns: conversation1.id, recipient_id: 2)
        #Conversation.should_receive(:create).and_return(conversation1)
        #PrivateMessage.should_receive(:create).and_return(message1)

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
      
      #it "creates a conversation id with a unique volunteer application foreign key"
      #it "makes the recipient of the message see a conversation, which has a volunteer_application_id" 
    end
  end
end