class Conversation < ActiveRecord::Base
  has_many :private_messages, -> {order('created_at ASC')}

  def sender_user_name_of_recent_message
    message = self.private_messages.last
    user = message.sender_id
    name = User.find_by(id: user)
    "#{name.first_name} #{name.last_name}"
  end

  def the_id_of_sender
    message = self.private_messages.last
    user = message.sender_id
    name = User.find_by(id: user)
    name.id
  end

  def private_message_subject
    message = self.private_messages.last
    message_subject = message.subject
  end

  def private_message_body
    message = self.private_messages.last
    message_body = message.body
  end
end