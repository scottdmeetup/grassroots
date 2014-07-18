require 'spec_helper'

describe OrganizationAdmin::ProjectsController, :type => :controller do
  let!(:first_submitted_project) {Fabricate(:badge, name: "First Submitted Project")}
  
  describe "GET new" do
    let!(:alice) {Fabricate(:organization_administrator, user_group: "nonprofit")}
    let!(:huggey_bears) {Fabricate(:organization, user_id: alice.id)}

    before do
      set_current_user(alice)
    end

    it "renders the new template for creating a project" do
      get :new

      expect(response).to render_template(:new)
    end

    it "only renders this page for organization administrators" do
      bob = Fabricate(:user, user_group: "nonprofit")
      set_current_user(bob)
      get :new

      expect(response).to redirect_to(user_path(bob.id))
    end

    it "initializes @project" do
      get :new

      expect(assigns(:project)).to be_a(Project)
    end

    it "sets the project admin variable" do
      get :new

      expect(assigns(:project).project_admin).to eq(alice)
    end

    context "when a skill has been created" do
      let!(:alice) {Fabricate(:organization_administrator, user_group: "nonprofit")}
      let!(:huggey_bears) {Fabricate(:organization, user_id: alice.id)}

      before do
        set_current_user(alice)
      end

      it "sets @project with the created project from the skill create action" do
        project = Project.create(organization_id: alice.administrated_organization.id)
        get :new, project_id: project.id

        expect(assigns(:project).id).to eq(1)
      end
    end
  end

  describe "POST create" do
    
    let!(:huggey_bears) {Fabricate(:organization, cause: "animals")}
    let!(:alice) {Fabricate(:organization_administrator, first_name: "Alice", organization_id: huggey_bears.id, user_group: "nonprofit")}
    let!(:bob) {Fabricate(:user, first_name: "Bob", user_group: "volunteer")}
    let!(:cat) {Fabricate(:user, first_name: "Cat", user_group: "volunteer")}

    before do
      huggey_bears.update_columns(user_id: alice.id)
      set_current_user(alice)
    end
    
    it "creates a project" do
      post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", organization_id: huggey_bears.id), commit: "Publish Project"
      expect(Project.count).to eq(1)
    end
    
    it "redirects to the organization administrator to the view project's show view" do
      post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", organization_id: huggey_bears.id), commit: "Publish Project"

      word_press = Project.first
      expect(response).to redirect_to(project_path(word_press.id))
    end

    it "creates a project associated with an organization" do
      post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", organization_id: huggey_bears.id), commit: "Publish Project"

      word_press = Project.first
      expect(word_press.organization).to eq(huggey_bears)
    end
    
    it "adds the created project to the organization's dashboard of projects" do
      post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", organization_id: huggey_bears.id), commit: "Publish Project"

      word_press = Project.first
      expect(huggey_bears.open_projects).to eq([word_press])
    end

    it "creates a project with a project type" do
      post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", project_type: "Web Development", organization_id: huggey_bears.id), commit: "Publish Project"

      word_press = Project.first
      expect(word_press.project_type).to eq("Web Development")
    end

    it "creates a project associated with the organization's cause" do
      post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", organization_id: huggey_bears.id), commit: "Publish Project"

      word_press = Project.first
      expect(word_press.causes).to eq("animals")
    end

    it "sets the project's state to open" do
      post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", organization_id: huggey_bears.id), commit: "Publish Project"

      word_press = Project.first
      expect(word_press.state).to eq("open")
    end
    
    it "creates a newsfeed item" do
      post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", organization_id: huggey_bears.id), commit: "Publish Project"

      expect(NewsfeedItem.count).to eq(1)
    end

    it "publishes this as activity on the newsfeed of others who follow the current user" do
      Fabricate(:relationship, follower_id: bob.id, leader_id: alice.id )
      graphic_design = Fabricate(:project, title: "graphic design", organization_id: huggey_bears.id)
      newsfeed_item2 = NewsfeedItem.create(user_id: alice.id)
      graphic_design.newsfeed_items << newsfeed_item2

      post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", organization_id: huggey_bears.id), commit: "Publish Project"

      item = NewsfeedItem.first
      item2 = NewsfeedItem.last
      expect(NewsfeedItem.from_users_followed_by(bob)).to match_array([item, item2])
    end

    context "when a user adds required skills to a project" do
      let!(:alice) {Fabricate(:organization_administrator, first_name: "Alice", user_group: "nonprofit")}
      let!(:huggey_bear) {Fabricate(:organization, user_id: alice.id)}
      let!(:graphic_design) {Fabricate(:skill, name: "Graphic Design")}

      before(:each) do
        set_current_user(alice)
      end

      it "redirects back to the project creation page" do
        post :create, skill: {name: "Adobe"}, commit: "Add Skill"

        expect(response).to redirect_to(new_organization_admin_project_path(project_id: Project.first.id))
      end

      it "associates a skill with the project" do
        post :create, skill: {name: "Graphic Design"}, commit: "Add Skill"

        expect(assigns(:project).skills).to match_array([graphic_design])
      end

      it "creates a new skill if skill does not exist" do
        post :create, skill: {name: "Ruby on Rails"}, commit: "Add Skill"
        
        expect(Skill.count).to eq(2)
      end

      it "creates a project" do
        post :create, skill: {name: "Ruby on Rails"}, commit: "Add Skill"
        
        expect(Project.count).to eq(1)
      end

      it "does not create another project when adding another skill" do
        project = Project.create(organization_id: alice.administrated_organization.id)
        project.skills << graphic_design
        post :create, skill: {name: "Ruby on Rails"}, commit: "Add Skill", project_id: project.id
        
        expect(Project.count).to eq(1)
      end

      it "creates a project draft if it creates a project" do
        post :create, skill: {name: "Ruby on Rails"}, commit: "Add Skill"
        
        project = Project.first
        expect(project.project_draft).to eq(ProjectDraft.first)
      end

      it "does not create a project draft if the project has one" do
        project = Project.create(organization_id: alice.administrated_organization.id)
        ProjectDraft.create(organization_id: alice.administrated_organization.id, project_id: project.id)
        post :create, skill: {name: "Ruby on Rails"}, commit: "Add Skill", project_id: project.id
        
        expect(ProjectDraft.count).to eq(1)
      end
    end

    context "when saving a draft of a project" do
      it "creates a project when there is not a created project with skills" do
        post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", organization_id: huggey_bears.id), commit: "Save Draft"

        expect(Project.count).to eq(1)
      end

      it "does not create a project when there is a created project with skills" do
        project = Project.create(organization_id: alice.administrated_organization.id)
        post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", id: project.id, organization_id: huggey_bears.id), commit: "Save Draft"

        expect(Project.count).to eq(1)
      end

      it "does not publish a newsfeed item" do
        post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", organization_id: huggey_bears.id), commit: "Save Draft"

        expect(NewsfeedItem.count).to eq(0)
      end

      it "is not searchable on the project index" do
        post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", organization_id: huggey_bears.id), commit: "Save Draft"

        expect(Project.first.state).to eq(nil)
      end

      it "creates a project with skill requirements" do
        rails = Fabricate(:skill, name: "Ruby on Rails")
        tdd = Fabricate(:skill, name: "Test Driven Development")
        project = Project.create(organization_id: alice.administrated_organization.id)
        project.skills << [rails, tdd]

        post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", id: project.id, organization_id: huggey_bears.id), commit: "Save Draft"

        word_press = Project.first
        expect(word_press.skills).to match_array([rails, tdd])
      end

      it "creates a project draft object" do
        post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", organization_id: huggey_bears.id), commit: "Save Draft"

        expect(ProjectDraft.count).to eq(1)
      end

      it "does not create two project draft objects when a draft has been saved already" do
        project = Project.create(organization_id: alice.administrated_organization.id)
        ProjectDraft.create(project_id: project.id, organization_id: alice.administrated_organization.id)
        post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", organization_id: huggey_bears.id, id: project.id), commit: "Save Draft"

        expect(ProjectDraft.count).to eq(1)
      end
    end

    context "when publishing a draft" do
      it "does not create another project" do
        rails = Fabricate(:skill, name: "Ruby on Rails")
        tdd = Fabricate(:skill, name: "Test Driven Development")
        project = Project.create(organization_id: alice.administrated_organization.id)
        project.skills << [rails, tdd]
        post :create, project: Fabricate.attributes_for(:project, title: "WordPress Site", id: project.id, organization_id: huggey_bears.id), commit: "Publish Project"

        expect(Project.count).to eq(1)
        expect(Project.first.state).to eq("open")
      end
    end
  end

  describe "GET edit" do
    it "renders a form for the current user's profile" do
      huggey_bears = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization_id: huggey_bears.id, user_group: "nonprofit")
      set_current_user(alice)
      word_press = Fabricate(:project, title: "WordPress Site", organization_id: huggey_bears.id)
      get :edit, id: word_press

      expect(response).to render_template(:edit)
    end
    it "sets the @project" do
      huggey_bears = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization_id: huggey_bears.id, user_group: "nonprofit")
      set_current_user(alice)
      word_press = Fabricate(:project, title: "WordPress Site", organization_id: huggey_bears.id)
      get :edit, id: word_press

      expect(assigns(:project)).to be_a Project
    end
  end

  describe "PATCH update" do
    it "redirects to the project page" do
      huggey_bears = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization_id: huggey_bears.id, user_group: "nonprofit")
      set_current_user(alice)
      word_press = Fabricate(:project, title: "WordPress Site", organization_id: huggey_bears.id)
      patch :update, id: alice.id, project: {description: "this site needs to be improved"} 

      expect(response).to redirect_to(project_path(word_press.id))
    end
    it "updates the project information" do
      huggey_bears = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization_id: huggey_bears.id, user_group: "nonprofit")
      set_current_user(alice)
      word_press = Fabricate(:project, title: "WordPress Site", organization_id: huggey_bears.id)
      patch :update, id: alice.id, project: {description: "this site needs to be improved"} 

      expect(assigns(:project).description).to eq("this site needs to be improved")
    end
    it "flashes a notice that the user updated his/her project" do
      huggey_bears = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization_id: huggey_bears.id, user_group: "nonprofit")
      set_current_user(alice)
      word_press = Fabricate(:project, title: "WordPress Site", organization_id: huggey_bears.id)
      patch :update, id: alice.id, project: {description: "this site needs to be improved"} 

      expect(flash[:success]).to eq("You updated your project")
    end
  end
end