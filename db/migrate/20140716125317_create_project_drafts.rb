class CreateProjectDrafts < ActiveRecord::Migration
  def change
    create_table :project_drafts do |t|
      t.integer :organization_id
    end
  end
end
