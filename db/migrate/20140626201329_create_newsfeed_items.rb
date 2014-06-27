class CreateNewsfeedItems < ActiveRecord::Migration
  def change
    create_table :newsfeed_items do |t|
      t.integer :user_id
      t.references :newsfeedable, polymorphic: true
      t.timestamps
    end
  end
end
