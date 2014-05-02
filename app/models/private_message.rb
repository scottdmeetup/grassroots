class PrivateMessage < ActiveRecord::Base
  belongs_to :recipient, foreign_key: 'recipient_id', class_name: 'User'
  belongs_to :sender, foreign_key: 'sender_id', class_name: 'User'

  validates_presence_of :subject, :body
end