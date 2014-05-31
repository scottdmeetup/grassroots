class VolunteerApplicationsController < ApplicationController
  def new
    @project = Project.find(params[:project_id])
    @private_message = PrivateMessage.new(project_id: params[:project_id], 
    recipient_id: @project.project_admin.id, subject: "Project Request: #{@project.title}")
  end

  def create
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

private

  def message_params
    params.require(:private_message).permit(:subject, :sender_id, :recipient_id, :body)
  end

end