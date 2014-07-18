require 'spec_helper'

describe ProjectDraft do
  it { should belong_to(:organization)}
  it { should belong_to(:project)}
  it { should have_many(:project_draft_skills)}
  it { should have_many(:skills).through(:project_draft_skills)}
end