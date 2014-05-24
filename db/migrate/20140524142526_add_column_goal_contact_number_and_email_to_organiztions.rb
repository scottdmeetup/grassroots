class AddColumnGoalContactNumberAndEmailToOrganiztions < ActiveRecord::Migration
  def change
    add_column :organizations, :goal, :text
    add_column :organizations, :contact_number, :string
    add_column :organizations, :contact_email, :string
  end
end
