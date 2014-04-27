require 'spec_helper'

describe Project do
  it { should belong_to(:organization)}
  it { should have_many(:users)}
end

  describe "#project_admin" do
    it "should return the administrator of the project" do
      alice = Fabricate(:organization_administrator)
      huggey_bears = Fabricate(:organization, user_id: alice.id)
      word_press = Fabricate(:project, organization: huggey_bears)
      expect(word_press.project_admin).to eq(alice)
    end
  end