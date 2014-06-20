class RemoveAndAddColumnCategorizations < ActiveRecord::Migration
  def change
    remove_column :categorizations, :questions_id
    remove_column :categorizations, :post_id
    add_column :categorizations, :question_id, :integer 
  end
end
