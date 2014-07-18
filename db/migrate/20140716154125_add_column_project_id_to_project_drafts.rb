class AddColumnProjectIdToProjectDrafts < ActiveRecord::Migration
  def change
    add_column :project_drafts, :project_id, :integer
  end
end
