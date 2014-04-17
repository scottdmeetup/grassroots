require 'spec_helper'

describe OrganizationsController do
  describe "GET show" do
    it "shows the organization's profile" do
      amnesty = Fabricate(:organization)
      get :show, id: amnesty
      expect(response).to render_template(:show)
    end
    it "shows the projects associated with an organization"
  end

  describe "GET new" do

  end

  describe "POST create" do
    it "creates an organization"
    it "makes the author of the form administrator of that organization"
  end
end