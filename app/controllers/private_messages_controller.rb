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

  def show
    @message = PrivateMessage.find(params[:id])
    @messages = Conversation.find_by(id: @message.conversation_id)
    @private_message = PrivateMessage.new(subject: @message.subject, recipient_id: @message.sender.id, sender_id: current_user.id, conversation_id: @message.conversation_id)
  end

  def outgoing_messages
    @messages = current_user.sent_messages
  end

private
  def message_params
    params.require(:private_message).permit(:subject, :sender_id, :recipient_id, :body)
  end

  def handles_reply
    if params[:private_message_id].present?
      @private_message = PrivateMessage.find_by(params[:private_message])
      @received_message = PrivateMessage.find_by(params[:private_message_id])
      @other_user = User.find(@received_message.sender_id)
      conversation = @received_message.conversation
      conversation.private_messages << @private_message
      conversation.users << [current_user, @other_user]
    end
  end

  def handles_join_request
    project = Project.find_by(params[:project_id])
    project.update_columns(state: "pending") if project
    current_user.projects << project if project
    addressee = User.find_by(@private_message.sender_id) unless params[:private_message_id].present?
    conversation = Conversation.create unless params[:private_message_id].present?
    conversation.private_messages << @private_message unless params[:private_message_id].present?
    addressee.conversations << conversation unless params[:private_message_id].present?
  end
end
