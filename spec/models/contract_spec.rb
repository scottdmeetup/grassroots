require 'spec_helper'

describe Contract do
  it {should belong_to(:volunteer)}
  it {should belong_to(:contractor)}
end