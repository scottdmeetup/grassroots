require 'spec_helper'

describe Relationship do
  it { should have_many(:newsfeed_items)}
  it { should belong_to(:follower)}
  it { should belong_to(:leader)}
end