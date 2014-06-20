require 'spec_helper'

describe Category do
  it { should have_many(:categorizations)}
  it { should have_many(:questions).through(:categorizations)}
end