require 'spec_helper'

describe Organization do
  it { should belong_to(:organization_administrator)}
  it { should have_many(:projects)}
  it { should have_many(:users)}


  describe "#organization_administrator" do
    it "should return the administrator of the organization" do
      huggey_bears = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization: huggey_bears, user_group: "nonprofit")
      huggey_bears.organization_administrator = alice
      expect(huggey_bears.organization_administrator).to eq(alice)
    end
  end

  describe "#open_projects" do
    it "returns the organization's open projects" do
      huggey_bears = Fabricate(:organization)
      word_press = Fabricate(:project, state: "open")
      logo = Fabricate(:project, state: "completed")
      huggey_bears.projects << [word_press, logo]

      expect(huggey_bears.open_projects).to eq([word_press])
    end
  end

  describe "#in_production_projects" do
    it "returns the organization's in production projects" do
      huggey_bears = Fabricate(:organization)
      word_press = Fabricate(:project, state: "in production")
      logo = Fabricate(:project, state: "completed")
      huggey_bears.projects << [word_press, logo]

      expect(huggey_bears.in_production_projects).to eq([word_press])
    end
  end
  describe "#pending_approval_projects" do
    it "returns the organization's pending approval projects" do
      huggey_bears = Fabricate(:organization)
      word_press = Fabricate(:project, state: "pending approval")
      logo = Fabricate(:project, state: "completed")
      huggey_bears.projects << [word_press]

      expect(huggey_bears.pending_approval_projects).to eq([word_press])
    end
  end
  describe "#completed_projects" do
    it "returns the organization's completed projects" do
      huggey_bears = Fabricate(:organization)
      word_press = Fabricate(:project, state: "open")
      logo = Fabricate(:project, state: "completed")
      huggey_bears.projects << [logo]

      expect(huggey_bears.completed_projects).to eq([logo])
    end
  end

  describe "#unfinished_projects" do
    it "returns the organization's unfinished projects" do
      huggey_bears = Fabricate(:organization)
      word_press = Fabricate(:project, state: "unfinished")
      logo = Fabricate(:project, state: "completed")
      huggey_bears.projects << [word_press, logo]

      expect(huggey_bears.unfinished_projects).to eq([word_press])
    end
  end
end