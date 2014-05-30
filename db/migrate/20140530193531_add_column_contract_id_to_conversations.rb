class AddColumnContractIdToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :contract_id, :integer
  end
end
