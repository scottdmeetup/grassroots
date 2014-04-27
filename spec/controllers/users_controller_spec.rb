require 'spec_helper'

describe UsersController do
  describe "GET show" do
    it "shows the user's profile" do
      alice = Fabricate(:user)
      get :show, id: alice
      expect(response).to render_template(:show)
    end
    it "shows the user's associated projects"
    context "when the user's type is defined"
      it "motivates the user to fill out their profile"
    context "when the user's type is undefined"
      it "alerts the user to identify itself as either, freelancer or staff of an organization"
    context "when the staff member's organization is not a present"
      it "asks the user to create a profile for his/her organization"
    context "when the staff member's organization is present"
      it "autopopulates the field"
      it "asks the user if he/she would like to request to join the organization"
      it "sends a staff approval notification to the administrator"
      it "notifies the user that an approval notification has been sent"
  end

  describe "PATCH/PUT edit" do
    ## Do a lot of the specs from the GET show belong here?
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
    it "redirects the user to its profile page"
  end
end