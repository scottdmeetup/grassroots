require 'spec_helper'

describe VolunteerApplication do
  it {should belong_to(:user)}
  it {should belong_to(:project)}
end