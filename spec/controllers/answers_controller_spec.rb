require 'spec_helper'

describe AnswersController, :type => :controller do
  describe "POST create" do
    let!(:alice) {Fabricate(:user, user_group: "nonprofit")}
    let!(:alice_question1) {Fabricate(:question, user_id: alice.id)}
    let!(:bob) {Fabricate(:user, user_group: "volunteer")}

    before(:each) do
      set_current_user(bob)
      request.env["HTTP_REFERER"] = "/questions/1" unless request.nil? or request.env.nil?
    end

    it "renders the show view of the question that it answers" do
      post :create, answer: {user_id: bob.id, description: "you want to do this and that"}, question_id: alice_question1.id

      expect(response).to redirect_to(question_path(alice_question1.id))
    end

    it "creates a answer" do
      post :create, answer: {user_id: bob.id, description: "you want to do this and that"}, question_id: alice_question1.id

      expect(Answer.count).to eq(1)
    end

    it "creates a question associated with a user" do
      post :create, answer: {user_id: bob.id, description: "you want to do this and that"}, question_id: alice_question1.id

      expect(Answer.first.author).to eq(bob)
    end
    it "creates a question associated with a question" do
      post :create, answer: {user_id: bob.id, description: "you want to do this and that"}, question_id: alice_question1.id

      expect(Answer.first.question).to eq(alice_question1)
    end

    it "does not create an answer which is an empty string" do
      post :create, answer: {user_id: bob.id, description: ""}, question_id: alice_question1.id

      expect(Answer.count).to eq(0)
    end
  end 
end