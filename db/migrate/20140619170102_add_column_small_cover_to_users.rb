class AddColumnSmallCoverToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :small_cover
    add_column :users, :small_cover, :string
  end
end
