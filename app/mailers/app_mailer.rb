class AppMailer < ActionMailer::Base
  def send_welcome_email(a_user_id)
    @user = User.find(a_user_id)
    mail to: @user.email, from: "info@grassroots.org", subject: "Welcome to Grassroots!"
  end

  def send_forgot_password(a_user_id)
    @user = User.find(a_user_id)
    mail to: @user.email, from: "info@grassroots.org", subject: "Please reset your password"
  end
end