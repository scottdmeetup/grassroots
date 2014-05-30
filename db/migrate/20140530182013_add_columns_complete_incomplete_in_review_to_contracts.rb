class AddColumnsCompleteIncompleteInReviewToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :complete, :boolean
    add_column :contracts, :incomplete, :boolean
    add_column :contracts, :work_submitted, :boolean
  end
end
