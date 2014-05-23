class User < ActiveRecord::Base
  has_secure_password validations: false
  belongs_to :organization
  belongs_to :project
  has_many :project_users
  has_many :projects, through: :project_users
  has_many :sent_messages, class_name: 'PrivateMessage', foreign_key: 'sender_id'
  has_many :received_messages, -> {order('created_at DESC')}, class_name: 'PrivateMessage', foreign_key: 'recipient_id'
  has_many :conversations

  def organization_name_box
    organization.try(:name)
  end

  def organization_name_box=(name)
    self.organization = Organization.find_by_name(name) if name.present?
  end

  def private_messages
    messages = self.sent_messages + self.received_messages
    messages.sort!
  end

  def user_conversations
    collection = self.received_messages.select(:conversation_id).distinct
    all_conversations = collection.map do |member|
      convo_id = member.conversation_id
      Conversation.find_by(id: convo_id)
    end  
    all_conversations.sort
  end

  def organization_name
    organization.name
  end

  def open_projects
    self.projects.select {|member| member.state.include?("open")}
  end

  def in_production_projects
    self.projects.select {|member| member.state.include?("in production")}
  end

  def pending_approval_projects
    self.projects.select {|member| member.state.include?("pending approval")}
  end

  def completed_projects
    self.projects.select {|member| member.state.include?("completed")}
  end

  def unfinished_projects
    self.projects.select {|member| member.state.include?("unfinished")}
  end
end