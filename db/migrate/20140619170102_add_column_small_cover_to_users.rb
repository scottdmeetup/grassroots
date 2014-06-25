class AddColumnSmallCoverToUsers < ActiveRecord::Migration
  def change
    add_column :users, :small_cover, :string
  end
end
