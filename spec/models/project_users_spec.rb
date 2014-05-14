require 'spec_helper'

describe ProjectUser do
  it { should belong_to(:user)}
  it { should belong_to(:project)}
end