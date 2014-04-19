class Organization < ActiveRecord::Base
  belongs_to :organization_administrator, foreign_key: 'user_id', class_name: 'User'  
end