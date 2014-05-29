class AddColumnProjectIdToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :project_id, :integer
  end
end
