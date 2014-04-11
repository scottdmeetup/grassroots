class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.datetime :ruling_year
      t.text :mission_statement
      t.string :guidestar_membership
      t.string :ein
      t.string :street1
      t.string :street2
      t.string :city
      t.integer :state_id
      t.string :zip
      t.integer :ntee_major_category_id
      t.string :funding_method
    end
  end
end
