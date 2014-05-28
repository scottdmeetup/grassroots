class Contract < ActiveRecord::Base
  belongs_to :contractor, foreign_key: 'contractor_id', class_name: 'User'
  belongs_to :volunteer, foreign_key: 'volunteer_id', class_name: 'User'
  belongs_to :project
end