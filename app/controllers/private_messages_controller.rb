class PrivateMessagesController < ApplicationController
  before_filter :current_user
  def new
    project = Project.find(params[:project_id])
    @private_message = PrivateMessage.new(project_id: params[:project_id], recipient_id: project.project_admin.id, subject: "Project Request: #{project.title}")
  end

  def create
    if params[:private_message][:conversation_id]
      @private_message = PrivateMessage.new(message_params.merge!(conversation_id: params[:private_message][:conversation_id]))
      @private_message.save
      redirect_to conversations_path
    else
      conversation = Conversation.create 
      @private_message = PrivateMessage.new(message_params.merge!(conversation_id: conversation.id))
      @private_message.save
      redirect_to conversations_path
    end
  end

  def outgoing_messages
    @messages = current_user.sent_messages
  end

private
  def message_params
    params.require(:private_message).permit(:subject, :sender_id, :recipient_id, :body)
  end
end