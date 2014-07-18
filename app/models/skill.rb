class Skill < ActiveRecord::Base
  has_many :talents
  has_many :users, through: :talents
  
  has_many :requirements
  has_many :projects, through: :requirements

  has_many :project_draft_skills
  has_many :projec_drafts, through: :project_draft_skills
  
end