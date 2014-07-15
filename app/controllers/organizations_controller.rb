class OrganizationsController < ApplicationController
  before_action :find_organization, only: [:show]
  
  def show
    @open_params = params[:tab] == 'open'
    @production_params = params[:tab] == 'in production'
    @work_submitted_params = params[:tab] == 'pending approval'
    @completed_params = params[:tab] == 'completed'
    @unifinished_params = params[:tab] == 'unfinished'
    @expired_params = params[:tab] == 'expired'

    @open_projects = @organization.open_projects
    @in_production_projects = @organization.in_production_projects
    @projects_with_work_submitted = @organization.projects_with_work_submitted
    @completed_projects = @organization.completed_projects
    @unfinished_projects = @organization.unfinished_projects
    @expired_projects = @organization.expired_projects

    respond_to do |format|
      format.html do
      end
      format.js
    end
  end

  def index
    @organizations = Organization.all
  end

  def search
    filter = {cause: params[:cause]} if params[:cause]
    
    if filter != nil
      @results = Organization.where(filter).to_a
      @results.sort! {|x,y| x.name <=> y.name }
    else
      @results = Organization.search_by_name(params[:search_term])
    end 
  end

private

  def organization_params
    params.require(:organization).permit(:name, :date_of_incorporation, 
      :ein, :street1, :street2, :city, :state_abbreviation, :zip, :cause, 
      :contact_number, :contact_email, :mission_statement, :goal, :user_id)
  end

  def find_organization
    @organization = Organization.find(params[:id])
  end
end