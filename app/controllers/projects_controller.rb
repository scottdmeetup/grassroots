class ProjectsController < ApplicationController
  before_action :current_user

  def index
    #@projects = Project.where(state: "open").where("self.deadline > Time.now")
    @projects = Project.where(state: "open").where("deadline > now")
    open_projects = Project.where(state: "open").to_a
    @projects = open_projects.select do |member|
      member.state == "open" && member.deadline > Date.today
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  def search
    if params[:search_term] && params[:search_term] != ""
      search_term = params[:search_term]
      #@results = Project.search_by_title_or_description(params[:search_term])
      #@results = Project.where("title OR description LIKE ?", "%#{search_term}%")
      @results_by_title = Project.where("title LIKE ?", "%#{search_term}%")
      @results_by_description = Project.where("description LIKE ?", "%#{search_term}%")
      @results = @results_by_title.concat(@results_by_description)
      @results.uniq!
      @results.to_a
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