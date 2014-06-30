class QuestionsController < ApplicationController
  before_action :authorize, only: [:create, :vote]
  before_action :set_question, only: [:vote, :show, :edit, :update]
  

  def index
    @questions = Question.all
  end

  def show
    @comment = Comment.new
    @answer = Answer.new
    @answers = @question.answers
    
  end

  def new
    @question = Question.new
  end

  def create
    if params[:question][:category_ids] == nil
      question = Question.new(question_params.merge!(category_ids: [1]))
      question.author = current_user
      question.save
      newsfeed_item = NewsfeedItem.create(user_id: current_user.id)
      question.newsfeed_items << newsfeed_item
      redirect_to questions_path
    else
      question = Question.new(question_params)
      question.author = current_user
      question.save
      newsfeed_item = NewsfeedItem.create(user_id: current_user.id)
      question.newsfeed_items << newsfeed_item
      redirect_to questions_path
    end
  end

  def edit; end

  def update
    @question.update_columns(question_params)
    redirect_to question_path(@question.id)
  end

  def vote
    if @question.author.id == current_user.id
      flash[:error] = "You cannot vote on your own question."
    else
      vote = Vote.create(voteable: @question, voter: current_user, vote: params[:vote]) 
      vote.valid? ? flash[:success] = "Thank you for voting." : flash[:error] = "You can only vote once on this question."
    end
    redirect_to :back
  end

private

  def question_params
    params.require(:question).permit(:title, :description, category_ids: [])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :user_id)
  end
end