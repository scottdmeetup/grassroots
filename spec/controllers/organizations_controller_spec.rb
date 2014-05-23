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
    it "creates an organization"
    it "makes the author of the form administrator of that organization"
  end
end