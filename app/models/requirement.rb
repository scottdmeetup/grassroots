class Requirement < ActiveRecord::Base
  belongs_to :project
  belongs_to :skill
end