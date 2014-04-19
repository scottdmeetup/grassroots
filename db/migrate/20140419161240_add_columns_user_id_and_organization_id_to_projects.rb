class AddColumnsUserIdAndOrganizationIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :user_id, :integer
    add_column :projects, :organization_id, :integer
  end
end
