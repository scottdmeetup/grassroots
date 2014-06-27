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

private

  def answer_params
    params.require(:answer).permit(:description)    
  end
end