class PrivateMessagesController < ApplicationController
  before_filter :current_user
  def new
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @project.state == "in production" ? handles_project_completed_request : handles_join_request
    else
      @user = User.find_by(id: params[:user_id])
      @private_message = PrivateMessage.new(recipient_id: @user.id)
    end
  end

  def create
    if when_replying_to_a_message
      handles_replies
    elsif when_requesting_to_join_project
      project = Project.find(params[:project_id])
      project.state == "open" ? handles_request_to_join_project : handles_completed_project_request
    else
      handles_first_private_message
    end
  end

  def outgoing_messages
    @messages = current_user.sent_messages
  end

private
  def when_replying_to_a_message
    params[:private_message][:conversation_id]
  end

  def when_requesting_to_join_project
    params[:project_id]
  end

  def message_params
    params.require(:private_message).permit(:subject, :sender_id, :recipient_id, :body)
  end
  
  def handles_join_request
    @private_message = PrivateMessage.new(project_id: params[:project_id], 
      recipient_id: @project.project_admin.id, subject: "Project Request: #{@project.title}")
  end

  def handles_project_completed_request
    PrivateMessage.find_by_project_id(@project.id).update_columns(project_id: nil)
    @private_message = PrivateMessage.new(project_id: params[:project_id], recipient_id: @project.project_admin.id, subject: "Project Completed: #{@project.title}")
  end

  def handles_replies
    @private_message = PrivateMessage.new(message_params.merge!(conversation_id: params[:private_message][:conversation_id]))
    @private_message.save
    redirect_to conversations_path
    flash[:success] = "Your message has been sent to #{@private_message.recipient.first_name} #{@private_message.recipient.last_name}"
  end

  def handles_request_to_join_project
    VolunteerApplication.create
    project = Project.find(params[:project_id])
    current_user.projects << project
    conversation = Conversation.create 
    @private_message = PrivateMessage.new(message_params.merge!(conversation_id: conversation.id, project_id: project.id))
    @private_message.save
    redirect_to conversations_path
    flash[:success] = "Your message has been sent to #{@private_message.recipient.first_name} #{@private_message.recipient.last_name}"
  end

  def handles_completed_project_request
    project = Project.find(params[:project_id])
    conversation = Conversation.create 
    @private_message = PrivateMessage.new(message_params.merge!(conversation_id: conversation.id, project_id: project.id))
    project.update(state: "pending completion")
    @private_message.save
    redirect_to user_path(current_user)
    flash[:success] = "Your message has been sent to #{@private_message.recipient.first_name} #{@private_message.recipient.last_name}"
  end

  def handles_first_private_message
    conversation = Conversation.create 
    @private_message = PrivateMessage.new(message_params.merge!(conversation_id: conversation.id))
    @private_message.save
    redirect_to conversations_path
  end
end