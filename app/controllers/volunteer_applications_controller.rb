class VolunteerApplicationsController < ApplicationController

  def new
    @volunteer_application = VolunteerApplication.new
    @private_message = PrivateMessage.new
  end

  def create
    @volunteer_application = VolunteerApplication.create(user_id: current_user.id, project_id: params[:project_id])
    sends_application_to_project_administrator(@volunteer_application)
    redirect_to conversations_path
  end

private

  def message_params
    params.permit(:subject, :sender_id, :recipient_id, :body)
  end

  def sends_application_to_project_administrator(application)
    conversation1_about_volunteer_application = Conversation.create
    message = PrivateMessage.create(message_params)
    message.update_columns(conversation_id: conversation1_about_volunteer_application.id)
    project_administrator = User.find(message.recipient_id)
    project_administrator.conversations << conversation1_about_volunteer_application
    conversation1_about_volunteer_application.update_columns(volunteer_application_id: application.id)
  end

  def creates_volunteer_application
    volunteer_application = VolunteerApplication.create(user_id: current_user.id, project_id: params[:project_id])
  end
end