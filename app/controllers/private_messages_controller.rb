class PrivateMessagesController < ApplicationController
  before_filter :current_user
  def new
    project = Project.find(params[:project_id])
    @private_message = PrivateMessage.new(project_id: params[:project_id], recipient_id: project.project_admin.id, subject: "Project Request: #{project.title}")
  end

  def create
    @private_message = PrivateMessage.new(message_params)
    if @private_message.save
      project = Project.find_by(params[:project_id])
      project.update_columns(state: "pending")
      current_user.projects << project
      flash[:success] = "Your join request has been sent."
      redirect_to private_messages_path
    else
      flash[:error] = "Please try again"
      render "new"
    end
  end

 

private
  def message_params
    params.require(:private_message).permit(:subject, :project_id, :sender_id, :recipient_id, :body)
  end
end