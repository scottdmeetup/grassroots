require 'spec_helper'

describe Question do
  it { should belong_to(:author)}
  it { should have_many(:categorizations)}
  it { should have_many(:categories).through(:categorizations)}
  it { should have_many(:answers)}
  it { should have_many(:comments)}
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
end