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
    context "with valid data" do
      it "creates the user" do
        post :create, user: {first_name: "Alice", last_name: "Smith", password: "password", email: "alice@example.com"}
        expect(User.count).to eq(1)
      end
      it "redirects the user to its profile page" do
        post :create, user: {first_name: "Alice", last_name: "Smith", password: "password", email: "alice@example.com"}
        user = User.first
        expect(response).to redirect_to(user_path(user.id))
      end

      it "sets the user with either a volunteer or nonprofit type" do
        post :create, user: {first_name: "Alice", last_name: "Smith", password: "password", email: "alice@example.com", user_group: "volunteer"}
        user = User.first
        expect(user.user_group).to eq("volunteer")
      end
    end
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
    context "when the user's organization is not present" do
      it "redirects the user to a form to create the organization" do
        alice = Fabricate(:user)
        patch :update, id: alice.id, user: {email: "test@example.com", organization_name_box: "The Red Cross", bio: "my life kicks ass"} 

        expect(response).to redirect_to(new_organization_path)
      end

      it "still updates the user's attributes" do
        alice = Fabricate(:user)
        patch :update, id: alice.id, user: {email: "test@example.com", organization_name_box: "The Red Cross", bio: "my life kicks ass"} 

        expect(alice.reload.email).to eq("test@example.com")
      end
    end

    context "when the user is a freelancer" do
    end
  end

  describe "DELETE remove" do
    it "redirects to the organization's profile page" do
      huggey_bear = Fabricate(:organization)
      alice = Fabricate(:user, organization_id: huggey_bear.id)

      delete :remove, id: alice.id
      expect(response).to redirect_to organization_path(huggey_bear.id)
    end
    it "unassociates the staff member selected from the organization" do
      huggey_bear = Fabricate(:organization)
      alice = Fabricate(:user, organization_id: huggey_bear.id)

      delete :remove, id: alice.id
      expect(alice.reload.organization_id).to be_nil
    end
  end
end