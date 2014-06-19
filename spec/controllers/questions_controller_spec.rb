require 'spec_helper'

describe QuestionsController, :type => :controller do
  describe "GET index" do

    let!(:alice) {Fabricate(:user, user_group: "nonprofit")}
    let!(:alice_question1) {Fabricate(:question, user_id: alice.id)}
    let!(:alice_question2) {Fabricate(:question, user_id: alice.id)}
    it "renders the index template" do
      get :index

      expect(response).to render_template(:index)
    end

    it "sets @questions" do
      alice = Fabricate(:user, user_group: "nonprofit")
      get :index

      expect(assigns(:questions)).to match_array([alice_question1, alice_question2])
    end
  end

  describe "GET show" do

    let!(:alice) {Fabricate(:user, user_group: "nonprofit")}
    let!(:alice_question1) {Fabricate(:question, user_id: alice.id)}

    it "renders the show template" do
      get :show, id: alice_question1.id

      expect(response).to render_template(:show)
    end

    it "sets @question" do
      get :show, id: alice_question1.id

      expect(assigns(:question)).to be_instance_of(Question)
    end
  end
end