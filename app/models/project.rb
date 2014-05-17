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
end