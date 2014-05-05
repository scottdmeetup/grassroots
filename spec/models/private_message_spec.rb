require 'spec_helper'

describe PrivateMessage do
  it {should belong_to(:recipient)}
  it {should belong_to(:conversation)}
end