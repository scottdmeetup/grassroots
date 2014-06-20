class AddColumnQuestionToCategorizations < ActiveRecord::Migration
  def change
    add_column :categorizations, :questions_id, :integer
  end
end
