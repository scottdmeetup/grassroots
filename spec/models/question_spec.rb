require 'spec_helper'

describe Question do
  it { should belong_to(:user)}
  #it { should have_many(:answers)}
  #it { should have_many(:comments)}
end