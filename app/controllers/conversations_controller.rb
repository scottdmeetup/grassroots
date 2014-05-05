class ConversationsController < ApplicationController
  def index
    @conversations = current_user.user_conversations
  end

  def show
    @conversation = Conversation.find(params[:id])
  end
end