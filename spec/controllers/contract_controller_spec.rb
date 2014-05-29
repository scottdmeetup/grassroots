require 'spec_helper'

describe ContractsController, :type => :controller do

  describe "POST create" do
    let(:huggey_bear) {Fabricate(:organization)}
    let(:alice) {Fabricate(:organization_administrator, user_group: "nonprofit")}
    let(:bob) {Fabricate(:user, user_group: "volunteer")}
    let(:word_press) {Fabricate(:project)}
    
    before do
      set_current_user(alice)
      huggey_bear.update_columns(user_id: alice.id)
    end

    it "renders the conversation show view" do
      post :create
      expect(response).to redirect_to(conversations_path)
    end
    it "creates a contract"

  end