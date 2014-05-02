class CreatePrivateMessages < ActiveRecord::Migration
  def change
    create_table :private_messages do |t|
      t.integer :sender_id
      t.integer  :recipient_id
      t.string  :subject
      t.text  :body
      t.timestamps
    end
  end
end
