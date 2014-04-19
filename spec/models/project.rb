require 'spec_helper'

describe Project do
  it { should belong_to(:organization)}
end

  describe "#admin" do
    it "should return the administrator of the project" do
      alice = Fabricate(:organization_administrator)
      huggey_bears = Fabricate(:organization, user_id: alice.id)
      word_press = Fabricate(:project, organization: huggey_bears)
      expect(word_press.admin).to eq(alice)
    end
  end