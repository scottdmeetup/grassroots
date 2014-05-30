require 'spec_helper'

describe ContractsController, :type => :controller do
  let(:huggey_bear) {Fabricate(:organization)}
  let(:alice) {Fabricate(:organization_administrator, first_name: "Alice", user_group: "nonprofit")}
  let(:bob) {Fabricate(:user, first_name: "Bob", user_group: "volunteer")}
  let(:cat) {Fabricate(:user, first_name: "Cat", user_group: "volunteer")}
  let(:dan) {Fabricate(:user, first_name: "Dan", user_group: "volunteer")}
  
  let(:logo) { Fabricate(:project, title: "need a logo", user_id: alice.id, organization_id: huggey_bear.id, state: "open")  }
  let(:word_press) { Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") }

  describe "POST create" do

    before do
      set_current_user(alice)
      huggey_bear.update_columns(user_id: alice.id)
      ##I have no idea how to refactor the test variables like application1, application2 
      #etc...into either let statements or before do
    end

    it "renders the conversation show view" do
      application1 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id) 
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project") 
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(response).to redirect_to(conversation_path(conversation1.id))
    end
    it "creates a contract" do
      application1 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id) 
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project") 
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(Contract.count).to eq(1)
    end

    it "makes the volunteer application accepted" do
      application1 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id) 
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project") 
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(application1.reload.accepted).to eq(true)
    end

    it "makes the volunteer's application rejected status, false" do
      application1 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id) 
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project") 
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(application1.reload.rejected).to eq(false)
    end
    it "makes the other volunteer applications rejected" do
      application1 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id) 
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project") 

      application2 = Fabricate(:volunteer_application, applicant_id: cat.id, administrator_id: alice.id, project_id: word_press.id)
      conversation2 = Fabricate(:conversation, volunteer_application_id: application2.id)  
      message2 = Fabricate(:private_message, recipient_id: alice.id, sender_id: cat.id, conversation_id: conversation2.id, subject: "Please let me join your project", body: "I'd like to contribute to your project") 

      application3 = Fabricate(:volunteer_application, applicant_id: dan.id, administrator_id: alice.id, project_id: word_press.id) 
      conversation3 = Fabricate(:conversation, volunteer_application_id: application3.id) 
      message3 = Fabricate(:private_message, recipient_id: alice.id, sender_id: dan.id, conversation_id: conversation3.id, subject: "Please let me join your project", body: "I'd like to contribute to your project") 
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(application2.reload.rejected).to eq(true)
      expect(application3.reload.rejected).to eq(true)
    end
    it "makes the contract active " do
      application1 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id) 
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project") 
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(Contract.first.active).to eq(true)
    end

    it "makes the organization administrator the owner of the contract" do
      application1 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id) 
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project") 
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(Contract.first.contractor_id).to eq(alice.id)
    end
    it "makes the the applicant the volunteer of the contract" do
      application1 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id) 
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project") 
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(Contract.first.volunteer_id).to eq(bob.id)
    end
    it "associated the project with the contract" do
      application1 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id) 
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project") 
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(Contract.first.project_id).to eq(word_press.id)
    end

    it "associated the volunteer with the project" do
      application1 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id) 
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project") 
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(bob.projects).to eq([word_press])
    end

    it "associates the project with the volunteer" do
      application1 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id) 
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project") 
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(word_press.volunteers).to eq([bob])
    end

    it "moves the project's state into, in production" do
      application1 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id) 
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project") 
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(bob.projects_in_production).to eq([word_press])
    end
  end

  describe "DELETE destroy" do

    before do
      set_current_user(alice)
      huggey_bear.update_columns(user_id: alice.id)
      #I have no idea how to refactor the test variables like application1, application2 
      #etc...into either let statements or before do
    end

    it "renders the conversation show view" do
      application1 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id, accepted: true, rejected: false) 
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
      message2 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")

      contract1 =  Fabricate(:contract, contractor_id: 1, volunteer_id: 2, active: true, project_id: 1)
      delete :destroy, id: contract1.id, conversation_id: conversation1.id

      expect(response).to redirect_to(conversation_path(conversation1.id))
    end
    it "sets the status of the contract, dropped_out, to true" do
      application1 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id, accepted: true, rejected: false) 
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I've accepted you to join")

      #contract1 = Contract.create(contractor_id: 1, volunteer_id: 2, active: true, project_id: 1)
      contract1 =  Fabricate(:contract, contractor_id: 1, volunteer_id: 2, active: true, project_id: 1)
      delete :destroy, id: contract1.id, conversation_id: conversation1.id

      expect(contract1.reload.dropped_out).to eq(true)
    end
    it "automates a message to both parties" do
      application1 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id, accepted: true, rejected: false) 
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I've accepted you to join")

      contract1 =  Fabricate(:contract, contractor_id: 1, volunteer_id: 2, active: true, project_id: 1)
      delete :destroy, id: contract1.id, conversation_id: conversation1.id

      expect(conversation1.private_messages.count).to eq(3)
    end
    it "moves the project back to open by clearing the project of its volunteers" do
      application1 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id, accepted: true, rejected: false) 
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I've accepted you to join")

      contract1 =  Fabricate(:contract, contractor_id: 1, volunteer_id: 2, active: true, project_id: 1)
      delete :destroy, id: contract1.id, conversation_id: conversation1.id

      expect(word_press.volunteers).to eq([])
    end
  end
  describe "PATCH submit_for_review" do
    it "moves the contracts state to in review and keeps the contract active as well"

  end
  describe "PATCH update" do

    before do
      set_current_user(alice)
      huggey_bear.update_columns(user_id: alice.id)
      #I have no idea how to refactor the test variables like application1, application2 
      #etc...into either let statements or before do
    end

    it "renders the conversation view" do
      conversation = Fabricate(:conversation) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation.id, subject: "Project Complete", body: "This project is done")
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, conversation_id: conversation.id, subject: "Please let me join your project", body: "I've accepted you to join")
      contract =  Fabricate(:contract, contractor_id: 1, volunteer_id: 2, active: true, project_id: 1, work_submitted: true)
      conversation.update(contract_id: contract.id)
      patch :update, id: contract.id, conversation_id: conversation.id

      expect(response).to redirect_to(conversation_path(conversation.id))
    end

    it "makes the contract complete" do
      conversation = Fabricate(:conversation) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation.id, subject: "Project Complete", body: "This project is done")
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, conversation_id: conversation.id, subject: "Please let me join your project", body: "I've accepted you to join")
      contract =  Fabricate(:contract, contractor_id: 1, volunteer_id: 2, active: true, project_id: 1, work_submitted: true)
      conversation.update(contract_id: contract.id)
      patch :update, id: contract.id, conversation_id: conversation.id

      expect(contract.reload.complete).to eq(true)
    end
  end
end