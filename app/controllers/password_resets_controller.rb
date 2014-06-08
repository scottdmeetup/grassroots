class PasswordResetsController < ApplicationController
  def show
    
    user = User.where(new_password_token: params[:id]).first
    if user
      @new_password_token = user.new_password_token
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.where(new_password_token: params[:new_password_token]).first
    if user
      user.password = params[:password]
      user.generate_token
      user.save
      flash[:success] = "Your password has been changed. Please sign in."
      redirect_to sign_in_path
    else
      redirect_to expired_token_path
    end
  end
end