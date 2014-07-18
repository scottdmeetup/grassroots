class ProjectDraftSkill < ActiveRecord::Base
  belongs_to :skill
  belongs_to :project_draft
end