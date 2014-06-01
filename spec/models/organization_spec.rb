require 'spec_helper'

describe Organization do
  it { should belong_to(:organization_administrator)}
  it { should have_many(:projects)}
  it { should have_many(:users)}

  let(:huggey_bear) {Fabricate(:organization)}
  let(:amnesty) {Fabricate(:organization)}
  let(:alice) {Fabricate(:organization_administrator, first_name: "Alice", user_group: "nonprofit")}
  let(:bob) {Fabricate(:user, first_name: "Bob", user_group: "volunteer")}
  let(:cat) {Fabricate(:organization_administrator, first_name: "Cat", user_group: "nonprofit")}

  let(:logo) {Fabricate(:project, title: "need a logo", user_id: cat.id, organization_id: amnesty.id)  }
  let(:word_press) {Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id) }


  describe "#organization_administrator" do
    it "should return the administrator of the organization" do
      huggey_bears = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization: huggey_bears, user_group: "nonprofit")
      huggey_bears.organization_administrator = alice
      expect(huggey_bears.organization_administrator).to eq(alice)
    end
  end

  describe "#open_projects" do
    before do
      huggey_bear.update_columns(user_id: alice.id)
      amnesty.update_columns(user_id: cat.id)
    end

    it "returns the organization's open projects" do
      
      accounting = Fabricate(:project, title: "didn't do my taxes", user_id: cat.id, organization_id: amnesty.id)
      grant_writing = Fabricate(:project, title: "need Grants", user_id: alice.id, organization_id: huggey_bear.id)
      professional_site = Fabricate(:project, title: "need a site", user_id: alice.id, organization_id: huggey_bear.id)

      contract1 =  Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: true, project_id: word_press.id)
      contract2 =  Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: false, incomplete: true, project_id: logo.id)
      contract3 = Fabricate(:contract, contractor_id: cat.id, volunteer_id: bob.id, active: nil, project_id: accounting.id)
      contract4 = Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: true, project_id: grant_writing.id, work_submitted: true)

      expect(huggey_bear.open_projects).to eq([professional_site])
    end
  end

  describe "#projects_with_work_submitted" do

    before do
      huggey_bear.update_columns(user_id: alice.id)
      amnesty.update_columns(user_id: cat.id)
    end

    it "returns the organization's projects that have received submitted work for the administrator to review" do
      accounting = Fabricate(:project, title: "didn't do my taxes", user_id: cat.id, organization_id: amnesty.id)

      contract1 =  Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: true, project_id: word_press.id, work_submitted: true)
      contract2 = Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: true, project_id: logo.id, work_submitted: true)
      contract3 = Fabricate(:contract, contractor_id: cat.id, volunteer_id: bob.id, active: true, project_id: accounting.id, work_submitted: false)
      
      expect(huggey_bear.projects_with_work_submitted).to eq([word_press, logo])
    end
  end

  describe "#completed_projects" do

    before do
      huggey_bear.update_columns(user_id: alice.id)
      amnesty.update_columns(user_id: cat.id)
    end

    it "returns the organization's projects with contracts completed" do
      
      accounting = Fabricate(:project, title: "didn't do my taxes", user_id: cat.id, organization_id: amnesty.id)

      contract1 =  Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: false, project_id: word_press.id, work_submitted: true, complete: true, incomplete: false)
      contract2 = Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: false, project_id: logo.id, work_submitted: true, complete: true, incomplete: false)
      contract3 = Fabricate(:contract, contractor_id: cat.id, volunteer_id: bob.id, active: true, project_id: accounting.id, work_submitted: false)

      expect(huggey_bear.completed_projects).to eq([word_press, logo])
    end
  end

  describe "#unfinished_projects" do

    before do
      huggey_bear.update_columns(user_id: alice.id)
      amnesty.update_columns(user_id: cat.id)
    end

    it "returns the organization's unfinished projects through invompleted projects" do
      accounting = Fabricate(:project, title: "didn't do my taxes", user_id: cat.id, organization_id: amnesty.id)

      contract1 =  Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: false, project_id: word_press.id, work_submitted: nil, complete: nil, incomplete: true)
      contract2 = Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: false, project_id: logo.id, work_submitted: nil, complete: nil, incomplete: true)
      contract3 = Fabricate(:contract, contractor_id: cat.id, volunteer_id: bob.id, active: true, project_id: accounting.id, work_submitted: false)

      expect(huggey_bear.unfinished_projects).to eq([word_press, logo])
    end
  end

  describe "#in_production_projects" do

    before do
      huggey_bear.update_columns(user_id: alice.id)
      amnesty.update_columns(user_id: cat.id)
    end

    it "returns all projects that have active contracts with no work submitted" do
      
      accounting = Fabricate(:project, title: "didn't do my taxes", user_id: cat.id, organization_id: amnesty.id)
      grant_writing = Fabricate(:project, title: "need Grants", user_id: alice.id, organization_id: huggey_bear.id)
      professional_site = Fabricate(:project, title: "need a site", user_id: alice.id, organization_id: huggey_bear.id)

      contract1 =  Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: true, project_id: word_press.id)
      contract2 =  Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: true, project_id: logo.id)
      contract3 = Fabricate(:contract, contractor_id: cat.id, volunteer_id: bob.id, active: nil, project_id: accounting.id)
      contract4 = Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: true, project_id: grant_writing.id, work_submitted: true)

      expect(huggey_bear.in_production_projects).to eq([word_press, logo])
    end
  end
end