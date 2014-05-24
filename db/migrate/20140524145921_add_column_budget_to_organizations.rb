class AddColumnBudgetToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :budget, :string
  end
end
