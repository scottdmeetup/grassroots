class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to(user_path(current_user))
    else
      render 'new'
    end
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "You are logged in!"
    else
      flash[:notice] = "Either the password or the email is invalid."
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You are logged out."
    redirect_to root_path
  end
end