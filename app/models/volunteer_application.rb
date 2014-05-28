class VolunteerApplication < ActiveRecord::Base
  belongs_to :applicant, foreign_key: 'applicant_id', class_name: 'User'
  belongs_to :administrator, foreign_key: 'administrator_id', class_name: 'User'
  belongs_to :project
end