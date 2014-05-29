class PrivateMessagesController < ApplicationController
  before_filter :current_user
  def new
    if project_related_message
      @project = Project.find(params[:project_id])
      @project.state == "in production" ? handles_project_complete : handles_volunteer_application
    else
      @user = User.find_by(id: params[:user_id])
      @private_message = PrivateMessage.new(recipient_id: @user.id)
    end
  end

  def create
    if user_creating_a_reply?
      handles_replies
    elsif volunteer_creating_an_application?
      project = Project.find(params[:project_id])
      project.state == "open" ? sends_application_to_project_administrator : handles_completed_project_request
    else
      handles_first_private_message
    end
  end

  def outgoing_messages
    @messages = current_user.sent_messages
  end

private

  def project_related_message
    params[:project_id]
  end

  def user_creating_a_reply?
    params[:private_message][:conversation_id]
  end

  def volunteer_creating_an_application?
    params[:project_id]
  end

  def message_params
    params.require(:private_message).permit(:subject, :sender_id, :recipient_id, :body)
  end
  
  def handles_volunteer_application
    @private_message = PrivateMessage.new(project_id: params[:project_id], 
      recipient_id: @project.project_admin.id, subject: "Project Request: #{@project.title}")
  end

  def handles_project_complete
    PrivateMessage.find_by_project_id(@project.id).update_columns(project_id: nil)
    @private_message = PrivateMessage.new(project_id: params[:project_id], recipient_id: @project.project_admin.id, subject: "Project Completed: #{@project.title}")
  end

  def handles_replies
    @private_message = PrivateMessage.new(message_params.merge!(conversation_id: params[:private_message][:conversation_id]))
    @private_message.save
    redirect_to conversations_path
    flash[:success] = "Your message has been sent to #{@private_message.recipient.first_name} #{@private_message.recipient.last_name}"
  end

  def sends_application_to_project_administrator
    @volunteer_application = VolunteerApplication.create(administrator_id: message_params[:recipient_id], applicant_id: current_user.id, project_id: params[:project_id])
    conversation1_about_volunteer_application = Conversation.create
    @message = PrivateMessage.create(message_params)
    @message.update_columns(conversation_id: conversation1_about_volunteer_application.id)
    @organization_administrator = User.find(@message.recipient_id)
    @organization_administrator.conversations << conversation1_about_volunteer_application
    current_user.conversations << conversation1_about_volunteer_application
    conversation1_about_volunteer_application.update_columns(volunteer_application_id: @volunteer_application.id)
    redirect_to conversations_path
    flash[:success] = "Your message has been sent to #{@message.recipient.first_name} #{@message.recipient.last_name}"
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