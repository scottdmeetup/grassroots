class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.integer :contractor_id
      t.integer :volunteer_id
      t.boolean :active
      t.timestamps
    end
  end
end
