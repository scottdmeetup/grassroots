class Conversation < ActiveRecord::Base
  has_many :private_messages, -> {order('created_at ASC')}

  def sender_user_name_of_recent_message
    message = self.private_messages.last 
    user = message.sender_id
    name = User.find_by(id: user)
    if name
      "#{name.first_name} #{name.last_name}"
    end
  end

  def the_id_of_sender
    message = self.private_messages.last
    user = message.sender_id
    name = User.find_by(id: user)
    if name
      name.id
    end
  end

  def private_message_subject
    message = self.private_messages.last
    message_subject = message.subject
  end

  def private_message_body
    message = self.private_messages.last
    message_body = message.body
  end

  def join_request
    message = self.private_messages.first
    project = Project.find_by(id: message.project_id)
    if project
      if project.users.count >= 2
        project.state == "open"
      end
    end
  end

  def with_work_submitted
    contract = Contract.find(self.contract_id)
    contract.active && contract.work_submitted
  end

  def with_opportunity_to_drop_job
    contract = Contract.find(self.contract_id)
    contract.active && contract.work_submitted == false && contract.created_at > 5.days.ago
  end
end