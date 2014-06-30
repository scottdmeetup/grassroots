class AnswersController < ApplicationController
  def create
    answer = Answer.new(answer_params)
    answer.author = current_user
    answer.question_id = params[:question_id]
    answer.save
    newsfeed_item = NewsfeedItem.create(user_id: current_user.id)
    answer.newsfeed_items << newsfeed_item
    redirect_to :back
  end

  def comment
    @answer = Answer.find(params[:id])
    @question = Question.find(params[:question_id])
    @comment = Comment.create(commentable: @answer, user_id: current_user.id, content: params[:comment][:content])
    redirect_to question_path(@question)
  end

private

  def answer_params
    params.require(:answer).permit(:description)    
  end
end