require 'spec_helper'

describe Question do
  it { should belong_to(:author)}
  it { should have_many(:answers)}
  it { should have_many(:comments)}
  it { should have_many(:votes)}
  it { should have_many(:categorizations)}
  it { should have_many(:categories).through(:categorizations)}
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "#total_votes" do

    let!(:alice) {Fabricate(:user, user_group: "nonprofit")}
    let!(:alice_question1) {Fabricate(:question, user_id: alice.id, title: "PHP Advice")}
    let!(:bob) {Fabricate(:user, user_group: "volunteer")}
    let!(:bob_question1) {Fabricate(:question, user_id: bob.id)}
    let!(:cat) {Fabricate(:user, user_group: "volunteer")}
    let!(:cat_question1) {Fabricate(:question, user_id: cat.id)}
    let!(:dan) {Fabricate(:user, user_group: "volunteer")}
    let!(:dan_question1) {Fabricate(:question, user_id: dan.id)}

    it "returns the difference between up and down votes" do
      vote1 = Fabricate(:vote, vote: true, user_id: alice.id, voteable: bob_question1)
      vote2 = Fabricate(:vote, vote: true, user_id: cat.id, voteable: bob_question1)
      vote3 = Fabricate(:vote, vote: false, user_id: dan.id, voteable: bob_question1)
      expect(bob_question1.total_votes).to eq(1)
    end
  end
end