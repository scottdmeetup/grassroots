class AddColumnDroppedOutToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :dropped_out, :boolean
  end
end
