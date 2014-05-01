require 'spec_helper'

describe ProjectsController do
  describe "GET index" do
    it "shows all of the projects on Grassroots" do
      word_press = Fabricate(:project, title: "WordPress Site")
      logo = Fabricate(:project, title: "Huggey Bear Logo")
      brochures = Fabricate(:project, title: "Schmancy Brochures")
      web_development = Fabricate(:project, title: "Maintain Drupal Site")

      get :index
      expect(assigns(:projects)).to match_array([word_press, logo, brochures, web_development])
    end
  end

  describe "GET show" do
    it "shows a project" do
      word_press = Fabricate(:project, title: "WordPress Site")

      get :show, id: word_press
      expect(assigns(:project)).to eq(word_press)
    end
    context "when there are other requests to join"
     it "shows all freenlancers thumbnails"
  end

  describe "GET request_join" do
    it "renders the new private message view" do
      get :join
      expect(response).to redirect_to new_private_message_path
    end
    it "shows a button in view to send a join request"
  end

  describe "POST join" do
    ##I do not know if this should change the project's state 
    ##when a PM is made to join or if PrivateMessage#create_join_request should    
  end
  describe "GET accept" do
    it "changes the projects state from pending to in production"
    it "makes the project move from the pending tab to the in production tab on the freelancer’s and the organization admin’s dashboard"
    it "notifies the user waiting for a response that someone accepted the user’s join request"
  end

  describe "GET complete" do
    it "changes the projects state from in production to completed"
    it "notifies the other user that this project is completed"
    it "sends a feedback form to all parties involved"
    it "moves the project from the tab, in production, to the tab, completed"
  end

  describe "GET request_join" do
    it "renders the new private message view" do
      get :request_join
      expect(response).to render_template('private_messages/new')
    end
    it "shows a button in view to send a join request"
  end

  describe "POST join"
    it "sends a private message to the organization admin"
    it "changes the project’s state change from open to pending"
    it "flash's a success notice that your join request has been sent"
    it "appears on the freelancer’s and organization admin’s dashboards respectively as a pending project"
    it "notifies the organization admin that a user wants to join his/her project"
  end
  describe "GET accept" do
    it "changes the projects state from pending to in production"
    it "makes the project move from the pending tab to the in production tab on the freelancer’s and the organization admin’s dashboard"
    it "notifies the user waiting for a response that someone accepted the user’s join request"
  end

  describe "GET complete" do
    it "changes the projects state from in production to completed"
    it "notifies the other user that this project is completed"
    it "sends a feedback form to all parties involved"
    it "moves the project from the tab, in production, to the tab, completed"
  end
end