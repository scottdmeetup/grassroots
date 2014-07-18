require 'spec_helper'

describe Skill do
  it { should have_many(:talents)}
  it { should have_many(:users).through(:talents)}
  it { should have_many(:requirements)}
  it { should have_many(:projects).through(:requirements) }
end