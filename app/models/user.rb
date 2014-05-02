class User < ActiveRecord::Base
  has_secure_password validations: false
  belongs_to :organization
  belongs_to :project
  has_many :projects
  has_many :sent_messages, class_name: 'PrivateMessage', foreign_key: 'sender_id'
  has_many :received_messages, class_name: 'PrivateMessage', foreign_key: 'recipient_id'

  def organization_name
    organization.name
  end
end