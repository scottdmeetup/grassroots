class PrivateMessagesController < ApplicationController
  before_filter :current_user
  def new
    @user = User.find_by(id: params[:user_id])
    @private_message = PrivateMessage.new(recipient_id: @user.id)
  end

  def create
    if user_creating_a_reply?
      handles_replies
    else
      handles_first_private_message
    end
  end

  def outgoing_messages
    @messages = current_user.sent_messages
  end

private
  

  def user_creating_a_reply?
    params[:private_message][:conversation_id]
  end

  def message_params
    params.require(:private_message).permit(:subject, :sender_id, :recipient_id, :body)
  end

  def handles_replies
    @private_message = PrivateMessage.new(message_params.merge!(conversation_id: params[:private_message][:conversation_id]))
    @private_message.save
    redirect_to conversations_path
    flash[:success] = "Your message has been sent to #{@private_message.recipient.first_name} #{@private_message.recipient.last_name}"
  end

  def handles_first_private_message
    conversation = Conversation.create 
    @private_message = PrivateMessage.new(message_params.merge!(conversation_id: conversation.id))
    @private_message.save
    redirect_to conversations_path
  end
end