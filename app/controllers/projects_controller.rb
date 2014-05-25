class ProjectsController < ApplicationController
  before_action :current_user

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
  end

  def search
    binding.pry
    filter = {skills: params[:skills]} if params[:skills]
    filter = {causes: params[:causes]}  if params[:causes]
    @results = Project.where(filter).to_a 
  end

private

  def project_params
    params.require(:project).permit(:title, :organization_id, :user_id, :description, :skills, :deadline)
  end
end