require 'spec_helper'

describe OrganizationAdmin::OrganizationsController, :type => :controller do

  describe "GET new" do
    let!(:huggey_bear) {Fabricate(:organization)}
    let!(:alice) {Fabricate(:organization_administrator, organization_id: huggey_bear.id, user_group: "nonprofit")}
    
    before do
      set_current_user(alice)
    end

    it "renders template new" do
      get :new
      
      expect(response).to render_template(:new)
    end
    it "sets the @organization" do
      get :new

      expect(assigns(:organization)).to be_an_instance_of(Organization)
    end
  end

  describe "POST create" do
    let!(:alice) {Fabricate(:organization_administrator, user_group: "nonprofit")}

    before do
      set_current_user(alice)
    end

    it "redirects to the created organization's page" do
      
      post :create, organization: Fabricate.attributes_for(:organization)

      organization = Organization.first
      expect(response).to redirect_to(organization_path(organization.id))
    end
    
    it "creates an organization" do
      
      post :create, organization: Fabricate.attributes_for(:organization)

      expect(Organization.count).to eq(1)

    end
    it "makes the author of the form the administrator of that organization" do
      
      post :create, organization: Fabricate.attributes_for(:organization)

      organization = Organization.first
      expect(organization.reload.organization_administrator).to eq(alice)
    end

    it "associates the organization with the user" do
      
      post :create, organization: Fabricate.attributes_for(:organization)

      huggey_bears = Organization.first
      expect(alice.reload.organization).to eq(huggey_bears)
    end

    it "should flash a notice about creating an organization" do
      post :create, organization: Fabricate.attributes_for(:organization)

      expect(flash[:success]).to eq("You created your organization.")
    end
  end

  describe "GET edit" do
    it "renders a form for the current user to edit the organization's profile" do
      huggey_bear = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization_id: huggey_bear.id, user_group: "nonprofit")
      set_current_user(alice)
      get :edit, id: huggey_bear.id

      expect(response).to render_template(:edit)
    end
    it "sets the @organization" do
      huggey_bear = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization_id: huggey_bear.id, user_group: "nonprofit")
      set_current_user(alice)
      get :edit, id: huggey_bear.id

      expect(assigns(:organization)).to eq(huggey_bear)
    end
  end
  
  describe "PATCH update" do
    it "redirects to the organization's profile page" do
      huggey_bear = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization_id: huggey_bear.id, user_group: "nonprofit")
      set_current_user(alice)
      patch :update, id: huggey_bear.id, organization: Fabricate.attributes_for(:organization)

      expect(response).to redirect_to(organization_path(Organization.first.id))
    end
    it "updates the user's information" do
      huggey_bear = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization_id: huggey_bear.id, user_group: "nonprofit")
      set_current_user(alice)
      patch :update, id: huggey_bear.id, organization: Fabricate.attributes_for(:organization, goal: "test 123")

      expect(huggey_bear.reload.goal).to eq("test 123")

    end
    it "flashes a notice that the user updated his/her profile" do
      huggey_bear = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization_id: huggey_bear.id, user_group: "nonprofit")
      set_current_user(alice)
      patch :update, id: huggey_bear.id, organization: Fabricate.attributes_for(:organization, goal: "test 123")

      expect(flash[:notice]).to eq("You have updated your organization's profile.")
    end
  end
end