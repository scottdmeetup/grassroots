class User < ActiveRecord::Base
  has_secure_password validations: false
  belongs_to :organization
  has_many :projects

  def organization_name
    organization.name
  end
end