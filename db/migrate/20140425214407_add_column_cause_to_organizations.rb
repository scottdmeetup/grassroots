class AddColumnCauseToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :cause, :string
  end
end
