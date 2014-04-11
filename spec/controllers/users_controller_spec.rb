require 'spec_helper'

describe UsersController do
  describe "GET show" do
    it "shows the user's profile" do
      alice = Fabricate(:user)
      get :show, id: alice
      expect(response).to render_template(:show)
    end
  end
end