require 'spec_helper'

describe Answer do
  it { should belong_to(:author)}
  it { should belong_to(:question)}
  it { should have_many(:comments)}
  it { should validate_presence_of(:description)}
end