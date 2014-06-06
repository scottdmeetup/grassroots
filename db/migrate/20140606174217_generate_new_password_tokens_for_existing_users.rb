class GenerateNewPasswordTokensForExistingUsers < ActiveRecord::Migration
  def change
    User.all.each do |user|
      user.update_columns(new_password_token: SecureRandom.urlsafe_base64)
    end
  end
end
