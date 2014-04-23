class Project < ActiveRecord::Base
  belongs_to :organization

  def project_admin
    organization.organization_administrator
  end
end