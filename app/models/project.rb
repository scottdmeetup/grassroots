class Project < ActiveRecord::Base
  belongs_to :organization
  belongs_to :administrator, foreign_key: 'user_id', class_name: 'Organization'
  has_one :project_draft

  has_many :volunteer_applications
  has_many :users, through: :volunteer_applications
  has_many :applicants, class_name: 'VolunteerApplication', foreign_key: 'applicant_id'
  has_many :applicants, through: :volunteer_applications

  has_many :contracts
  has_many :users, through: :contracts
  
  has_many :volunteers, class_name: 'Contract', foreign_key: 'volunteer_id'
  has_many :volunteers, through: :contracts, source: :volunteer

  has_many :contractors, class_name: 'Contract', foreign_key: 'contractor_id'
  has_many :contractors, through: :contracts, source: :contractor

  has_many :newsfeed_items, as: :newsfeedable

  has_many :requirements
  has_many :skills, through: :requirements

  def project_admin
    organization.organization_administrator
    User.find(organization.organization_administrator.id)
  end

  def open
    self.state == "open"
  end

  def self.search_by_title_or_description(search_term)
    return [] if search_term.blank?
    if where("title or description LIKE ?", "%#{search_term}%") != []
      where("title or description LIKE ?", "%#{search_term}%")
    elsif where("title LIKE ?", "%#{search_term}%") != []
      where("title LIKE ?", "%#{search_term}%")
    elsif where("description LIKE ?", "%#{search_term}%") != []
      where("description LIKE ?", "%#{search_term}%")
    else
      []
    end
  end

  def in_production?
    self.contracts.where(active: true, work_submitted: false, project_id: self.id).present?
  end

  def has_submitted_work?
    self.contracts.where(active: true, work_submitted: true, project_id: self.id).present?
  end

  def is_complete?
    self.contracts.where(active: false, work_submitted: true, complete: true, project_id: self.id).present?
  end

  def in_production_contract_id
    self.contracts.where(active: true, work_submitted: false, project_id: self.id).first
  end

  def is_unfinished?
    self.contracts.where(active: false, incomplete: true).present?
  end
end