class Project < ActiveRecord::Base
  belongs_to :organization
  has_many :users

  def project_admin
    organization.organization_administrator
  end
end