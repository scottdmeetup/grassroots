class AddColumnProgressStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile_progress_status, :integer
  end
end
