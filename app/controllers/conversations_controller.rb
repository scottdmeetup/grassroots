class ConversationsController < ApplicationController
  def index
    @conversations = current_user.user_conversations #unless current_user.user_conversations != [nil]
  end

  def show
    @conversation = Conversation.find(params[:id]) 
    @first_message = @conversation.private_messages.first
    @reply = PrivateMessage.new(subject: @first_message.subject, recipient_id: @first_message.sender.id, sender_id: current_user.id, conversation_id: @first_message.conversation_id)
  end
end