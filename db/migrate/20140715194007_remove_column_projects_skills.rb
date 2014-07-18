class RemoveColumnProjectsSkills < ActiveRecord::Migration
  def change
    remove_column :projects, :skills
  end
end
