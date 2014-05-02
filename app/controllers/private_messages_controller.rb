class PrivateMessagesController < ApplicationController
  def new
    project = Project.find(params[:project_id])
    @private_message = PrivateMessage.new(project_id: params[:project_id], recipient_id: project.project_admin.id)
  end

  def create
    @private_message = PrivateMessage.new(message_params)
    if @private_message.save
      project = Project.find_by(params[:project_id])
      project.update_columns(state: "pending")
      flash[:success] = "Your join request has been sent."
      redirect_to private_messages_path
    else
      flash[:error] = "Please try again"
      render "new"
    end
  end

  def index
    binding.pry
    @messages = current_user.sent_messages.all || current_user.received_messages.all
  end

private
  def message_params
    params.require(:private_message).permit(:subject, :project_id, :sender_id, :recipient_id, :body)
  end
end