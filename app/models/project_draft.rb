class ProjectDraft < ActiveRecord::Base
  belongs_to :organization
  has_many :project_draft_skills
  has_many :skills, through: :project_draft_skills
  belongs_to :project
end