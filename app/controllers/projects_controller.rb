class ProjectsController < ApplicationController
  before_action :current_user

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
  end

  def join
    render 'show'
  end

private

  def project_params
    params.require(:project).permit(:title, :organization_id, :user_id, :description, :skills, :deadline)
  end
end