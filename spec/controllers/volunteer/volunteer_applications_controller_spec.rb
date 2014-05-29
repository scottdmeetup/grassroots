require 'spec_helper'

describe Volunteer::VolunteerApplicationsController, :type => :controller do
=begin
	describe "GET index" do
    let(:huggey_bear) { Fabricate(:organization) }
    let(:alice) { Fabricate(:organization_administrator, organization_id: huggey_bear.id, user_group: "nonprofit") }
    let(:bob) {Fabricate(:user, first_name: "Bob", user_group: "volunteer")}
    let(:cat) {Fabricate(:user, first_name: "Cat", user_group: "volunteer")}
    let(:word_press) {Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open")}
    let(:logo) {Fabricate(:project, title: "need a logo", user_id: alice.id, organization_id: huggey_bear.id, state: "open") }
    
    #let(:application1) {Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id)}
    #let(:conversation1) {Fabricate(:conversation, volunteer_application_id: application1.id) }
    #let(:message1) {Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)}
    
    #let(:application2) {Fabricate(:volunteer_application, applicant_id: cat.id, administrator_id: alice.id, project_id: logo.id)}
    #let(:conversation2) {Fabricate(:conversation, volunteer_application_id: application2.id)} 
    #let(:message2) {Fabricate(:private_message, recipient_id: cat.id, sender_id: bob.id, conversation_id: conversation2.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: logo.id)}

    before do
      set_current_user(bob)
    end

    it "renders the index template of the conversations controller" do
      get :index

      expect(response).to render_template('conversations/index')
    end

    it "assigns @open_applications, which contains an array of the applications that the volunteer has sent" do
      application1 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: word_press.id)
      conversation1 = Fabricate(:conversation, volunteer_application_id: application1.id)
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id)
    
      application2 = Fabricate(:volunteer_application, applicant_id: bob.id, administrator_id: alice.id, project_id: logo.id)
      conversation2 = Fabricate(:conversation, volunteer_application_id: application2.id)
      message2 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation2.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: logo.id)

      get :index
      expect(assigns(:open_applications)).to match_array([application1, application2])
    end
  end
=end
end