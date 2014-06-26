require 'spec_helper'

describe Comment do
  it { should belong_to(:question)}
  it { should belong_to(:answer)}
  it { should belong_to(:author)}
  it { should validate_presence_of(:content)}
end