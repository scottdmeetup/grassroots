class CreateVolunteerApplications < ActiveRecord::Migration
  def change
    create_table :volunteer_applications do |t|
      t.integer :user_id
      t.integer :project_id
      t.boolean :accepted
      t.boolean :rejected
      t.timestamps
    end
  end
end
