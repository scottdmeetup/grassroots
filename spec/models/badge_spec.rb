require 'spec_helper'

describe Badge do
  it { should have_many(:accomplishments)}
  it { should have_many(:users).through(:accomplishments)}
end