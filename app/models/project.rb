class Project < ActiveRecord::Base
  belongs_to :organization

  def admin
    organization.organization_administrator
  end
end