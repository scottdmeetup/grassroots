class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    respond_to do |format|
      format.html do
        @user = User.find(params[:id])
        #@applied_to_projects = @user.applied_to_projects if @user.applied_to_projects
        #@projects_in_production = @user.projects_in_production if @user.projects_in_production
        #@submitted_work = @user.submitted_work if @user.submitted_work
        #@completed_projects = @user.projects_complete if @user.projects_complete
      end
      format.js
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      AppMailer.delay.send_welcome_email(@user.id)
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
    else
      flash[:notice] = "Please try again."
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    organization = Organization.find_by(name: params[:user][:organization_name_box])
    
    if organization.nil? && current_user.user_group == "nonprofit"
      @user.update_columns(user_params.merge!(organization_administrator: true))
      redirect_to new_organization_admin_organization_path
    elsif current_user.user_group == "nonprofit" && @user.update_columns(user_params.merge!(organization_id: organization.id))
      @user.update_columns(user_params)
      flash[:notice] = "You have updated your profile successfully."
      redirect_to user_path(@user.id)
    elsif current_user.user_group == "volunteer"
      @user.update_columns(user_params)
      flash[:notice] = "You have updated your profile successfully."
      redirect_to user_path(@user.id)
    else
      flash[:error] = "Please try again."
      render :edit
    end
  end

  def remove
    user = User.find(params[:id])
    organization = Organization.find(user.organization_id)
    user.update_columns(organization_id: nil)
    redirect_to organization_path(organization.id)
  end

  def search

    filter = {skills: params[:skills]} if params[:skills]
    filter = {interests: params[:interests]}  if params[:interests]
    filter = {state_abbreviation: params[:state_abbreviation]} if params[:state_abbreviation]
    filter = {city: params[:city]} if params[:city]
    filter = {position: params[:position]} if params[:position]
    filter = {interests: params[:interests]} if params[:interests]
    
    if filter != nil
      @results = User.where(filter).to_a
      @results.sort! {|x,y| x.last_name <=> y.last_name }
    end 
  end

private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, 
      :organization_id, :bio, :skills, :interests, :position, :user_group, :contact_reason)
  end
end