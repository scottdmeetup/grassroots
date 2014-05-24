class AddColumnStateAbbreviationToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :state_abbreviation, :string
  end
end
