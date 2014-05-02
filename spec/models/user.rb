require 'spec_helper'

describe User do
  it { should belong_to(:organization)}
  it { should belong_to(:project)}
  it { should have_many(:projects)}
  it { should have_many(:sent_messages)}
  it { should have_many(:received_messages)}
  it {should belong_to(:project)}
  describe "#organization_name" do
    it "returns the name of the user's organization" do
      amnesty = Fabricate(:organization)
      alice = Fabricate(:user, organization: amnesty)
      
      expect(alice.organization_name).to eq(amnesty.name)
    end
  end
end
  