require 'spec_helper'

describe PasswordResetsController, :type => :controller do
  describe "GET show" do
    it "renders show template if hte token is valid" do
      alice = Fabricate(:user, user_group: "volunteer")
      alice.update_columns(new_password_token: '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end

    it "sets @new_password_token" do
      alice = Fabricate(:user, user_group: "volunteer")
      alice.update_columns(new_password_token: '12345')
      get :show, id: '12345'
      expect(assigns(:new_password_token)).to eq('12345')
    end
    it "redirects to the expired token page if the token is not valid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do
    context "with valid token" do
      it "redirects to the sign in page" do
        alice = Fabricate(:user, password: 'old_password', user_group: "volunteer")
        alice.update_columns(new_password_token: '12345')
        post :create, new_password_token: '12345', password: 'new_password'

        expect(response).to redirect_to sign_in_path
      end

      it "updates the user's password" do
        alice = Fabricate(:user, password: 'old_password', user_group: "volunteer")
        alice.update_columns(new_password_token: '12345')
        post :create, new_password_token: '12345', password: 'new_password'

        expect(alice.reload.authenticate('new_password')).to be_truthy
      end

      it "sets the flash success message" do
        alice = Fabricate(:user, password: 'old_password', user_group: "volunteer")
        alice.update_columns(new_password_token: '12345')
        post :create, new_password_token: '12345', password: 'new_password'

        expect(flash[:success]).to be_present
      end
      it "regenerates the user token" do
        alice = Fabricate(:user, password: 'old_password', user_group: "volunteer")
        alice.update_columns(new_password_token: '12345')
        post :create, new_password_token: '12345', password: 'new_password'

        expect(alice.reload.new_password_token).not_to eq('12345')
      end
    end
    context "with invalid token" do
      it "redirect to the expired token path" do
        post :create, token: '12345', password: 'some_password'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end