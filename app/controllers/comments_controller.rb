class CommentsController < ApplicationController
  before_action :authorize, only: [:create, :vote]

  def create
    @question = Question.find(params[:question_id]) if params[:question_id]
    @answer = Answer.find(params[:answer_id]) if params[:answer_id]
    if @question && @answer
      @comment = Comment.create(commentable: @answer, user_id: current_user.id, content: params[:comment][:content])
    else
      @comment = Comment.create(commentable: @question, user_id: current_user.id, content: params[:comment][:content])
    end
    redirect_to :back
  end

  def vote
    @comment = Comment.find(params[:id])
    if @comment.author.id == current_user.id
      flash[:error] = "You cannot vote on your own comment."
    else
      vote = Vote.create(voteable: @comment, voter: current_user, vote: params[:vote]) 
      vote.valid? ? flash[:success] = "Thank you for voting." : flash[:error] = "You can only vote once on this comment."
    end
    redirect_to :back
  end
end