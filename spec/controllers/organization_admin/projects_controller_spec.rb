require 'spec_helper'

describe OrganizationAdmin::ProjectsController do
  describe "GET new" do
    it "renders the new template for creating a project" do
      alice = Fabricate(:user, organization_administrator: true)
      set_current_user(alice)
      get :new
      expect(response).to render_template(:new)
    end
    it "only renders this page for organization administrators" do
      bob = Fabricate(:user, organization_administrator: false)
      set_current_user(bob)
      get :new
      expect(response).to redirect_to(user_path(bob.id))
    end
    it "sets the @project" do
      alice = Fabricate(:user, organization_administrator: true)
      set_current_user(alice)
      
      get :new
      expect(assigns(:project)).to be_a Project
    end
    context "when a project type is selected"
      it "shows a link to desk.com with documentat that is associated with that project type"
  end

  describe "POST create" do
    context "with valid inputs"
      it "creates a project" do
        set_current_admin
        post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site")
        expect(Project.count).to eq(1)
      end
      it "redirects to the organization administrator's organization page" do
        alice = Fabricate(:organization_administrator)
        set_current_admin(alice)
        post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site")
        expect(response).to redirect_to(organization_path(alice.organization.id))
      end
      it "creates a project associated with an organization" do
        alice = Fabricate(:organization_administrator)
        huggey_bears = Fabricate(:organization, user_id: alice.id)
        set_current_admin(alice)
        post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", organization: huggey_bears)

        word_press = Project.first
        expect(word_press.organization).to eq(huggey_bears)
      end
      it "creates a project associated with the administrator of an organization" do
        alice = Fabricate(:organization_administrator)
        huggey_bears = Fabricate(:organization, user_id: alice.id)
        set_current_admin(alice)
        post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", organization: huggey_bears)

        word_press = Project.first
        expect(word_press.admin).to eq(alice)
      end
      it "creates a project associated with a work-type" do
        alice = Fabricate(:organization_administrator)
        huggey_bears = Fabricate(:organization, user_id: alice.id)
        set_current_admin(alice)
        post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", organization: huggey_bears, skills: "Web Development")

        word_press = Project.first
        expect(word_press.skills).to eq("Web Development")
      end
      it "notifies the user that his/her project has been completed"
    context "when project fits the skill set of a freelancer"
      it "creates a notification for this type of freelancer"
    context "when project does not fit the skill set of a freelancer"
      it "does not create notification for this type of freelancer"
    context "with invalid inputs"
      it "alerts the user to retry the project form"
  end
end