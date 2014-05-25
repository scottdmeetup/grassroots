class ProjectsController < ApplicationController
  before_action :current_user

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
  end

  def search
    if params[:search_term]
      search_term = params[:search_term]
      @results_by_title = Project.where("title LIKE ?", "%#{search_term}%")
      @results_by_description = Project.where("description LIKE ?", "%#{search_term}%")
      @results = @results_by_title.concat(@results_by_description)
      @results.to_a
      @results.uniq!
      #@results = Project.search_by_title_or_description(params[:search_term])
    else
      filter = {skills: params[:skills]} if params[:skills]
      filter = {causes: params[:causes]}  if params[:causes]
      @results = Project.where(filter).to_a
    end
  end

private

  def project_params
    params.require(:project).permit(:title, :organization_id, :user_id, 
      :description, :skills, :deadline)
  end
end