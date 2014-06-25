class AddColumnSmallCover < ActiveRecord::Migration
  def change
    add_column :badges, :small_cover, :string
  end
end
