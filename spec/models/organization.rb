require 'spec_helper'

describe Organization do
  it { should belong_to(:organization_administrator)}
end