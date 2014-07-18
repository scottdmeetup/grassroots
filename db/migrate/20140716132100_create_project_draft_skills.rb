class CreateProjectDraftSkills < ActiveRecord::Migration
  def change
    create_table :project_draft_skills do |t|
      t.integer :skill_id
      t.integer :project_draft_id
      t.timestamps
    end
  end
end
