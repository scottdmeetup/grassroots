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

private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, 
      :organization_id, :bio, :skills, :interests, :position, :user_group)
  end

end