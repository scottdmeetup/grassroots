require 'spec_helper'

describe CommentsController, :type => :controller do
  describe "POST create" do
    
    let!(:alice) {Fabricate(:user, user_group: "nonprofit")}
    let!(:alice_question1) {Fabricate(:question, user_id: alice.id)}
    let!(:bob) {Fabricate(:user, user_group: "volunteer")}

    before(:each) do
      set_current_user(bob)
      request.env["HTTP_REFERER"] = "/questions/1" unless request.nil? or request.env.nil?
    end

    it "redirects user to the question show view when commenting on a question" do
      post :create, comment: {content: "this is a great question"}, question_id: alice_question1.id

      expect(response).to redirect_to(question_path(alice_question1.id))
    end
    it "redirects user to the answer show view when commenting on an answer" do
      bob_answer = Fabricate(:answer, question_id: alice_question1.id)

      post :create, comment: {content: "this is a great question"}, question_id: alice_question1.id, answer_id: bob_answer.id
      
      expect(response).to redirect_to(question_path(alice_question1.id))
    end
    it "creates a comment" do
      post :create, comment: {content: "this is a great question"}, question_id: alice_question1.id

      expect(Comment.count).to eq(1)
    end
    it "creates a comment associated with an author" do
      post :create, comment: {content: "this is a great question"}, question_id: alice_question1.id

      expect(Comment.first.author).to eq(bob)
    end
    it "creates a comment associated with a question when commenting on a question" do
      post :create, comment: {content: "this is a great question"}, question_id: alice_question1.id

      expect(Comment.first.question).to eq(alice_question1)
    end
    it "creates a comment associated with a answer when commenting on a answer" do
      bob_answer = Fabricate(:answer, question_id: alice_question1.id)
      post :create, comment: {content: "this is a great question"}, question_id: alice_question1.id, answer_id: bob_answer.id

      expect(Comment.first.answer).to eq(bob_answer)
    end

    it "sets the content attribute of the comment with the submitted parameters" do
      post :create, comment: {content: "this is a great question"}, question_id: alice_question1.id

      expect(Comment.first.content).to eq("this is a great question")
    end

    it "does not create a comment with empty content" do
      post :create, comment: {content: ""}, question_id: alice_question1.id

      expect(Comment.count).to eq(0)
    end
  end
end