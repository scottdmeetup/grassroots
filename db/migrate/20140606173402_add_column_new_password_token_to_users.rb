class AddColumnNewPasswordTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :new_password_token, :string
  end
end
