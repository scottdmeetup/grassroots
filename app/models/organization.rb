class Organization < ActiveRecord::Base
  belongs_to :organization_administrator, foreign_key: 'user_id', class_name: 'User'  
  has_many :projects
  has_many :users

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