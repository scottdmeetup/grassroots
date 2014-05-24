class AddColumnContactReasonAndOrganizationRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :contact_reason, :string
    add_column :users, :organization_role, :string
  end
end
