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

    it "sets @comment" do
      get :show, id: alice_question1.id

      expect(assigns(:comment)).to be_instance_of(Comment)
    end

    it "sets @answers" do
      bob = Fabricate(:user, user_group: "volunteer")
      bob_answer = Fabricate(:answer, description: "You need to do this......", question_id: alice_question1.id, user_id: bob.id)
      get :show, id: alice_question1

      expect(assigns(:answers)).to match_array([bob_answer])
    end

    it "shows the answers comments" do
      bob = Fabricate(:user, user_group: "volunteer")
      bob_answer = Fabricate(:answer, description: "You need to do this......", question_id: alice_question1.id, user_id: bob.id)
      alice_comment = Comment.create(user_id: alice.id, content: "thank you!", answer_id: bob_answer.id)
      get :show, id: alice_question1

      expect(bob_answer.comments).to match_array([alice_comment])
    end

    it "shows the questions comments" do
      bob = Fabricate(:user, user_group: "volunteer")
      bob_comment = Comment.create(user_id: bob.id, content: "can you clarify your question?", question_id: alice_question1.id)
      get :show, id: alice_question1

      expect(alice_question1.comments).to match_array([bob_comment])
    end
  end

  describe "GET new" do
    let!(:alice) {Fabricate(:user, user_group: "nonprofit")}

    it "renders the new template for creating a project" do
      get :new
      expect(response).to render_template(:new)
    end

    it "sets @question" do
      get :new
      expect(assigns(:question)).to be_instance_of(Question)
    end
  end

  describe "POST create" do
    let!(:alice) {Fabricate(:user, user_group: "nonprofit")}
    let!(:uncategorized) {Fabricate(:category, name: "Uncategorized")}
    let!(:web_development) {Fabricate(:category, name: "Web Development")}
    let!(:graphic_design) {Fabricate(:category, name: "Graphic Design")}
    let!(:social_media) {Fabricate(:category, name: "Social Media")}

    before do
      set_current_user(alice)
    end

    it "redirects to the questions index" do
      post :create, question: {title: "WordPress?", description: "Should I use wordpress, yo?"}

      expect(response).to redirect_to(questions_path)
    end

    it "creates a question" do
      post :create, question: {title: "WordPress?", description: "Should I use wordpress, yo?"}

      expect(Question.count).to eq(1)
    end

    it "creates a question associated with a user" do
      post :create, question: {title: "WordPress?", description: "Should I use wordpress, yo?"}

      expect(Question.first.author).to eq(alice)
    end
    it "creates a question associated with uncategorized category when unselected" do
      post :create, question: {title: "WordPress?", description: "Should I use wordpress, yo?"}

      question = Question.first
      expect(question.categories).to eq([uncategorized])
    end

    it "creates a question associated with a category when selected" do
      post :create, question: {title: "WordPress?", description: "Should I use wordpress, yo?", category_ids: [web_development.id]}

      question = Question.first
      expect(question.categories).to eq([web_development])
    end

    it "creates a question associated with more than one category" do
      post :create, question: {title: "WordPress?", description: "Should I use wordpress, yo?", category_ids: [web_development.id, social_media.id]}

      question = Question.first
      expect(question.categories).to eq([web_development, social_media])
    end
  end
end