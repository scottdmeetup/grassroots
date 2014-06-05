class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: "info@grassroots.org", subject: "Welcome to Grassroots!"
  end
end