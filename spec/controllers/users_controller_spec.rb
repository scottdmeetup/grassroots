require 'spec_helper'

describe UsersController do
  describe "GET show" do
    it "shows the user's profile" do
      alice = Fabricate(:user)
      get :show, id: alice
      expect(response).to render_template(:show)
    end
  end

  describe "GET new" do
    it "renders the new template for unauthenticated users" do
      get :new
      expect(response).to render_template(:new)
    end
    it "sets @user to a new user" do
      get :new
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of User
    end
  end

  describe "POST create" do
    it "creates the user" do
      post :create, user: {first_name: "Alice", last_name: "Smith", password: "password", email: "alice@example.com"}
      expect(User.count).to eq(1)
    end
    it "redirects to the"
  end
end