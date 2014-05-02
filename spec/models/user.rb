require 'spec_helper'

describe User do
  it { should belong_to(:organization)}
  it { should belong_to(:project)}
  it { should have_many(:projects)}
<<<<<<< HEAD
  it { should have_many(:sent_messages)}
  it { should have_many(:received_messages)}
=======
  it {should belong_to(:project)}
>>>>>>> 1d970b7... sets the projects state to the value, 'open', in implementation and in tests
  describe "#organization_name" do
    it "returns the name of the user's organization" do
      amnesty = Fabricate(:organization)
      alice = Fabricate(:user, organization: amnesty)
      
      expect(alice.organization_name).to eq(amnesty.name)
    end
  end
end
  