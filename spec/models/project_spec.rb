require 'spec_helper'

describe Project do
  it { should belong_to(:organization)}
  it { should have_many(:users)}
  it { should have_many(:project_users)}
  it { should have_many(:users).through(:project_users)}

  describe "#project_admin" do
    it "should return the administrator of the project" do
      alice = Fabricate(:organization_administrator)
      huggey_bears = Fabricate(:organization, user_id: alice.id)
      word_press = Fabricate(:project, organization: huggey_bears)
      expect(word_press.project_admin).to eq(alice)
    end
  end

  describe "#open" do
    context "when the project has the state, open" do
      it "should return true" do
        word_press = Fabricate(:project, state: "open")
        expect(word_press.open).to eq(true)
      end
    end

    context "when the project does not have the state, open" do
      it "should return false" do
        word_press = Fabricate(:project, state: "pending")
        expect(word_press.open).to eq(false)
      end
    end

  end
end