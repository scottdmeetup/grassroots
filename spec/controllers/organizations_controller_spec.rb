require 'spec_helper'

describe OrganizationsController do
  describe "GET show" do
    it "shows the organization's profile" do
      amnesty = Fabricate(:organization)
      get :show, id: amnesty
      expect(response).to render_template(:show)
    end
  end
end