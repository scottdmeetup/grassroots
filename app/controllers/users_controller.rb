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
    @user.save
    session[:user_id] = @user.id
    redirect_to projects_path
  end

private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

end