class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :organization_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :interests
      t.string :skills
      t.string :street1
      t.string :street2
      t.string :city
      t.integer :state_id
      t.integer :phone_number
      t.string :zip
      t.boolean :organization_administrator
      t.boolean :organization_staff
      t.boolean :volunteer
      t.timestamps
    end
  end
end
