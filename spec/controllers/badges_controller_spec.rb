require 'spec_helper'

describe BadgesController, :type => :controller do
  describe "GET show" do
    let!(:profile_completion) {Fabricate(:badge, name: "100% User Profile Completion")}
    it "renders the show view" do
      get :show, id: profile_completion
      expect(response).to render_template :show
    end

    it "sets @badge" do
      get :show, id: profile_completion
      expect(assigns(:badge)).to be_instance_of(Badge)
    end
    
  end
end
