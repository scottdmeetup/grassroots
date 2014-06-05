class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      AppMailer.send_welcome_email(@user).deliver
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
    if organization.nil?
      @user.update_columns(user_params)
      redirect_to new_organization_path
    elsif @user.update_columns(user_params.merge!(organization_id: organization.id))
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

    if params[:search_term]
      #search_term = params[:search_term]
      #@results_by_title = Project.where("title LIKE ?", "%#{search_term}%")
      #@results_by_description = Project.where("description LIKE ?", "%#{search_term}%")
      #@results = @results_by_title.concat(@results_by_description)
      #@results.to_a
      #@results.uniq!
      #@results = Project.search_by_title_or_description(params[:search_term])
    else
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
  end

private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, 
      :organization_id, :bio, :skills, :interests, :position, :user_group)
  end
end