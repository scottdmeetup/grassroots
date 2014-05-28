class AddColumnVolunteerApplicationToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :volunteer_application_id, :integer
  end
end
