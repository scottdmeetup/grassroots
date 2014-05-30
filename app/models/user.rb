class User < ActiveRecord::Base
  has_secure_password validations: false
  belongs_to :organization
  #belongs_to :project
  
  has_many :sent_messages, class_name: 'PrivateMessage', foreign_key: 'sender_id'
  has_many :received_messages, -> {order('created_at DESC')}, class_name: 'PrivateMessage', foreign_key: 'recipient_id'
  has_many :conversations
  
  has_many :received_applications, class_name: 'VolunteerApplication', foreign_key: 'administrator_id'
  has_many :projects, through: :volunteer_applications, source: :administrator
  has_many :sent_applications, class_name: 'VolunteerApplication', foreign_key: 'applicant_id'
  has_many :projects, through: :volunteer_applications, source: :applicant
  
  has_many :contracts, class_name: 'Contract', foreign_key: 'volunteer_id'
  has_many :projects, through: :contracts

  validates_presence_of :email, :password, :first_name, :last_name, :user_group
  validates_uniqueness_of :email

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

  def projects_in_production
    in_production = contracts.map do |member|
      in_production = Project.where(member.project_id).to_a  
    end
    in_production.uniq!
    in_production[0]
  end
=begin
  def open_projects
    self.projects.select {|member| member.state.include?("open")}
  end

  def in_production_projects
    self.projects.select {|member| member.state.include?("in production")}
  end

  def pending_completion_projects
    self.projects.select {|member| member.state.include?("pending completion")}
  end

  def completed_projects
    self.projects.select {|member| member.state.include?("completed")}
  end

  def unfinished_projects
    self.projects.select {|member| member.state.include?("unfinished")}
  end


  def projects_of_open_volunteer_applications
    collection_project_ids = volunteer_applications.where(accepted: nil, rejected: nil).select(:project_id).distinct
    all_open_applications = collection_project_ids.map do |member|
      proj_id = member.project_id
      Project.find(proj_id)
    end
    all_open_applications
  end  

  #def volunteers_open_applications
  #  volunteer_applications.where(accepted: nil, rejected: nil).to_a
  #end

  def administrators_open_applications
    collection_project_ids = self.organization.projects.map(&:id)
    all_volunteer_applications = collection_project_ids.map do |member|
      VolunteerApplication.find(member)
    end 
    all_volunteer_applications
  end

  def applied_to_projects
    project_applications = sent_applications.map do |member|
      project_applications = Project.find(member.project_id)
    end
    project_applications.sort!
  end
=end
end