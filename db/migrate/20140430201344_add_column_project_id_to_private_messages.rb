class AddColumnProjectIdToPrivateMessages < ActiveRecord::Migration
  def change
    add_column :private_messages, :project_id, :integer
  end
end
