class Organization < ActiveRecord::Base
  belongs_to :organization_administrator, foreign_key: 'user_id', class_name: 'User'  
  has_many :projects
  has_many :users

  def open_projects
    self.projects.select {|member| member.state.include?("open")}
  end

  def in_production_projects
    org_project_ids = projects.map(&:id)
    projects_with_contracts_with_nils = org_project_ids.map do |member|
      Contract.find_by(project_id: member) 
    end 
    projects_with_contracts = projects_with_contracts_with_nils.compact
    active_projects = projects_with_contracts.select { |member| member.active && !member.dropped_out && !member.complete && !member.incomplete && !member.work_submitted}
    active_projects.map do |member|
      Project.find(member.project_id)
    end

    #contracts_in_production = organization_administrator.contracts.where(active: true, work_submitted: nil).to_a
    #contracts_in_production.map do |member|
    #  Project.find(member.project_id)
    #end
  end

  def projects_with_work_submitted
    contracts_reflecting_work_submitted = organization_administrator.contracts.where(active: true, work_submitted: true).to_a
    contracts_reflecting_work_submitted.map do |member|
      Project.find(member.project_id)
    end
  end

  def completed_projects
    completed_contracts = organization_administrator.contracts.where(active: false, work_submitted: true, complete: true, incomplete: false).to_a
    completed_contracts.map do |member|
      Project.find(member.project_id)
    end
  end

  def unfinished_projects
    unfinished_contracts = organization_administrator.contracts.where(incomplete: true).to_a
    unfinished_contracts.map do |member|
      Project.find(member.project_id)
    end
  end
end