class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
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

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    @question.update_columns(question_params)
    redirect_to question_path(@question.id)
  end

private

  def question_params
    params.require(:question).permit(:title, :description, category_ids: [])
  end
end