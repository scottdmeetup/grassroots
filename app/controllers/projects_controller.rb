class ProjectsController < ApplicationController
  before_action :current_user

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
  end

  def join
<<<<<<< HEAD
    redirect_to new_private_message_path
=======
    render 'show'
>>>>>>> 433a5fc... sets up the start of writing out specs for a private messaging system
  end

private

  def project_params
    params.require(:project).permit(:title, :organization_id, :user_id, :description, :skills, :deadline)
  end
end