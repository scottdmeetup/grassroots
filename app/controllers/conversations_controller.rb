class ConversationsController < ApplicationController
  def index
    @conversations = current_user.user_conversations
  end

  def show
    @messages = Conversation.find_by(id: params[:id]) 
    @message = PrivateMessage.find_by(conversation_id: @messages.id)
    @private_message = PrivateMessage.new(subject: @message.subject, recipient_id: @message.sender.id, sender_id: current_user.id, conversation_id: @message.conversation_id)
  end
end