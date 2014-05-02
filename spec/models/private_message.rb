require 'spec_helper'

describe PrivateMessage do
  it {should belong_to(:recipient)}
end