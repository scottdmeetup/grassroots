class ConversationsController < ApplicationController
  
  def index
    if current_user.user_conversations != [nil]
      @conversations = current_user.user_conversations
    end
  end

  def show
    @conversation = Conversation.find(params[:id]) 
    @first_message = @conversation.private_messages.first
    @reply = PrivateMessage.new(subject: @first_message.subject, recipient_id: @first_message.sender.id, sender_id: current_user.id, conversation_id: @first_message.conversation_id)
  end
end