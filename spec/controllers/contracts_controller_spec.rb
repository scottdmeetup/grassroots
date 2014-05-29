require 'spec_helper'

describe ContractsController, :type => :controller do

  describe "POST create" do
    let(:huggey_bear) {Fabricate(:organization)}
    let(:alice) {Fabricate(:organization_administrator, first_name: "Alice", user_group: "nonprofit")}
    let(:bob) {Fabricate(:user, first_name: "Bob", user_group: "volunteer")}
    let(:cat) {Fabricate(:user, first_name: "Cat", user_group: "volunteer")}
    
    before do
      set_current_user(alice)
      huggey_bear.update_columns(user_id: alice.id)
    end

    it "renders the conversation show view" do
      logo = Fabricate(:project, title: "need a logo", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 

      application1 = VolunteerApplication.create(user_id: bob.id, project_id: word_press.id)
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(response).to redirect_to(conversation_path(conversation1.id))
    end
    it "creates a contract" do
      logo = Fabricate(:project, title: "need a logo", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 

      application1 = VolunteerApplication.create(applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id)
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(Contract.count).to eq(1)
    end

    it "makes the volunteer application accepted" do
      logo = Fabricate(:project, title: "need a logo", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 

      application1 = VolunteerApplication.create(applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id)
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(application1.reload.accepted).to eq(true)
    end

    it "makes the volunteer's application rejected status, false" do
      logo = Fabricate(:project, title: "need a logo", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 

      application1 = VolunteerApplication.create(applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id)
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(application1.reload.rejected).to eq(false)
    end
    it "makes the other volunteer applications rejected" do

      logo = Fabricate(:project, title: "need a logo", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 

      application1 = VolunteerApplication.create(applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id)
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)

      application2 = VolunteerApplication.create(applicant_id: cat.id, administrator_id: alice.id, project_id: logo.id)
      conversation2 = Fabricate(:conversation, volunteer_application_id: application2.id) 
      message2 = Fabricate(:private_message, recipient_id: alice.id, sender_id: cat.id, conversation_id: conversation2.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: logo.id)
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(application2.reload.rejected).to eq(true)
    end
    it "makes the contract active " do
      logo = Fabricate(:project, title: "need a logo", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 

      application1 = VolunteerApplication.create(applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id)
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(Contract.first.active).to eq(true)
    end
    it "makes the organization administrator the owner of the contract" do
      logo = Fabricate(:project, title: "need a logo", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 

      application1 = VolunteerApplication.create(applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id)
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(Contract.first.contractor_id).to eq(alice.id)
    end
    it "makes the the applicant the volunteer of the contract" do
      logo = Fabricate(:project, title: "need a logo", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 

      application1 = VolunteerApplication.create(applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id)
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(Contract.first.volunteer_id).to eq(bob.id)
    end
    it "makes the contract take the project id" do
      logo = Fabricate(:project, title: "need a logo", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open") 

      application1 = VolunteerApplication.create(applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id)
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id) 
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)
      post :create, volunteer_application_id: conversation1.volunteer_application_id, conversation_id: conversation1.id

      expect(Contract.first.project_id).to eq(word_press.id)
    end
    
  end
end