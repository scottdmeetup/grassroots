class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :question_id
      t.integer :answer_id
      t.integer :user_id
    end
  end
end
