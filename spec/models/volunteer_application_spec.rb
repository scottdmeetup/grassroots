require 'spec_helper'

describe VolunteerApplication do
  it {should belong_to(:applicant)}
  it {should belong_to(:administrator)}
end