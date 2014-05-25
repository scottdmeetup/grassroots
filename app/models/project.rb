class Project < ActiveRecord::Base
  belongs_to :organization
  has_many :project_users
  has_many :users, through: :project_users

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
end