require 'spec_helper'

describe Organization do
  it { should belong_to(:organization_administrator)}
end

  describe "#organization_administrator" do
    it "should return the administrator of the organization" do
      huggey_bears = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization: huggey_bears)
      huggey_bears.organization_administrator = alice
      expect(huggey_bears.organization_administrator).to eq(alice)
    end
  end