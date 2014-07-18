class AddColumnProjectTypeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :project_type, :string
  end
end
