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
  end

  describe "GET new" do
    it "sets the @project"
    context "when a project type is selected"
      it "shows a link to desk.com with documentat that is associated with that project type"
  end

  describe "POST create" do
    context "with valid inputs"
      it "creates a project"
      it "redirects to the project index"
      it "creates a project associated with an organization"
      it "creates a project associated with the administrator of an organization"
      it "creates a project associated with a work-type"
      it "notifies the user that his/her project has been completed"
    context "when project fits the skill set of a freelancer"
      it "creates a notification for this type of freelancer"
    context "when project does not fit the skill set of a freelancer"
      it "does not create notification for this type of freelancer"
    context "with invalid inputs"
      it "alerts the user to retry the project form"
  end
end