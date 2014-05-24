require 'spec_helper'

describe OrganizationsController, :type => :controller do
  describe "GET show" do
    it "renders the organization show template" do
      amnesty = Fabricate(:organization)
      get :show, id: amnesty
      expect(response).to render_template(:show)
    end
    it "shows the organization's profile" do
      amnesty = Fabricate(:organization)
      get :show, id: amnesty.id
      expect(assigns(:organization)).to eq(amnesty)

    end
    it "shows the projects associated with an organization"
  end

  describe "GET new" do
    it "renders template new" do
      get :new
      expect(response).to render_template(:new)
    end
    it "sets the @organization" do
      get :new
      expect(assigns(:organization)).to be_an_instance_of(Organization)
    end
  end

  describe "GET index" do
    it "renders the organization show template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "sets the @organiziations" do
      amnesty = Fabricate(:organization)
      global = Fabricate(:organization)
      huggey_bears = Fabricate(:organization)
      get :index
      expect(assigns(:organizations)).to eq([amnesty, global, huggey_bears])
    end
  end

  describe "POST create" do
    it "redirects to the created organization's page" do
      alice = Fabricate(:user)
      set_current_user(alice)
      post :create, organization: Fabricate.attributes_for(:organization)

      organization = Organization.first
      expect(response).to redirect_to(organization_path(organization.id))
    end
    
    it "creates an organization" do
      alice = Fabricate(:user)
      set_current_user(alice)
      post :create, organization: Fabricate.attributes_for(:organization)

      expect(Organization.count).to eq(1)

    end
    it "makes the author of the form the administrator of that organization" do
      alice = Fabricate(:user)
      set_current_user(alice)
      post :create, organization: Fabricate.attributes_for(:organization)

      organization = Organization.first
      expect(organization.reload.organization_administrator).to eq(alice)
    end

    it "associates the organization with the user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      post :create, organization: Fabricate.attributes_for(:organization)

      huggey_bears = Organization.first
      expect(alice.reload.organization).to eq(huggey_bears)
    end
  end
end