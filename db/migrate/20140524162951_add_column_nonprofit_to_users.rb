class AddColumnNonprofitToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nonprofit, :boolean
  end
end
