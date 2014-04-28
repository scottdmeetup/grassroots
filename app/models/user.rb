class User < ActiveRecord::Base
  has_secure_password validations: false
  belongs_to :organization
  has_many :projects
  belongs_to :project

  def organization_name
    organization.name
  end
end