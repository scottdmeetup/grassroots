class AddColumnStateAbbreviationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :state_abbreviation, :string
  end
end
