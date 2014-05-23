require 'spec_helper'

describe UsersController, :type => :controller do
  describe "GET index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "sets @users" do
      bob = Fabricate(:user, first_name: "Bob", last_name: "Smith")
      alice = Fabricate(:user, first_name: "Alice", last_name: "Smith")
      cat = Fabricate(:user, first_name: "Cat", last_name: "Smith")

      get :index
      expect(assigns(:users)).to match_array([bob, alice, cat])
    end
  end
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

  describe "GET edit" do
    it "renders a form for the current user's profile" do
      alice = Fabricate(:user)
      get :edit, id: alice.id

      expect(response).to render_template(:edit)
    end
    
    it "sets the @user" do
      alice = Fabricate(:user)
      get :edit, id: alice.id

      expect(assigns(:user)).to be_a User
    end
  end

  describe "PATCH update" do
    context "when the user is affiliated with an organization" do
      it "redirects to the user's profile page" do
        huggey_bear = Fabricate(:organization)
        alice = Fabricate(:user)
        patch :update, id: alice.id, user: {email: "test@example.com", organization_name_box: huggey_bear.name} 

        expect(response).to redirect_to(user_path(alice.id))
      end
      it "updates the user's information" do
        huggey_bear = Fabricate(:organization)
        alice = Fabricate(:user)
        patch :update, id: alice.id, user: {last_name: "Adams", organization_name_box: huggey_bear.name} 

        expect(alice.reload.last_name).to eq("Adams")
      end
      it "flashes a notice that the user updated his/her profile" do
        huggey_bear = Fabricate(:organization)
        alice = Fabricate(:user)
        patch :update, id: alice.id, user: {email: "test@example.com", organization_name_box: huggey_bear.name} 
        
        expect(flash[:notice]).to eq("You have updated your profile successfully.")
      end
    end
  end
end