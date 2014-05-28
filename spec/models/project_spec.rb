require 'spec_helper'

describe Project do
  it { should belong_to(:organization)}
  it { should have_many(:users)}
  #it { should have_many(:project_users)}
  #it { should have_many(:users).through(:project_users)}
  it { should have_many(:volunteer_applications)}
  it { should have_many(:users).through(:volunteer_applications)}

  describe "#project_admin" do
    it "should return the administrator of the project" do
      alice = Fabricate(:organization_administrator, user_group: "nonprofit")
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

  describe ".search_by_title_or_description" do
    context "when searching by title" do
      it "should return an empty array if the user submits no parameters" do
        word_press = Fabricate(:project, title: "WordPress")
        logo = Fabricate(:project, title: "New Logo")

        expect(Project.search_by_title_or_description("")).to eq([])
      end
      it "should return an empty array if it finds no projects" do
        word_press = Fabricate(:project, title: "WordPress")
        logo = Fabricate(:project, title: "New Logo")

        expect(Project.search_by_title_or_description("accounting")).to eq([])
      end
      it "should return an array of one project if it is an exact match" do
        word_press = Fabricate(:project, title: "WordPress")
        logo = Fabricate(:project, title: "New Logo")

        expect(Project.search_by_title_or_description("WordPress")).to eq([word_press])
      end
      it "should return an array of one project for a partial match" do
        word_press_1 = Fabricate(:project, title: "WordPress")
        logo = Fabricate(:project, title: "New Logo")

        expect(Project.search_by_title_or_description("word")).to eq([word_press_1])
      end
      it "should return an array of all matches oredered by created_at" do
        word_press_1 = Fabricate(:project, title: "WordPress")
        logo = Fabricate(:project, title: "New Logo")
        word_press_2 = Fabricate(:project, title: "Word press for nonprofit")

        expect(Project.search_by_title_or_description("word")).to eq([word_press_1, word_press_2])
      end
    end

    context "when searching by description" do
      it "should return an array of one project for an exact match in the description" do
        word_press_1 = Fabricate(:project, title: "Website", description: "help us make a wordpress site.")
        logo = Fabricate(:project, title: "New Logo", description: "we need help with graphic design work")
        word_press_2 = Fabricate(:project, title: "A website for nonprofit", description: "we need to revamp our droople site.")

        expect(Project.search_by_title_or_description("wordpress")).to eq([word_press_1])
      end

      it "should return an array of one project for a partial match in the description" do
        word_press_1 = Fabricate(:project, title: "Website", description: "help us make a wordpress site.")
        logo = Fabricate(:project, title: "New Logo", description: "we need help with graphic design work")
        word_press_2 = Fabricate(:project, title: "A website for nonprofit", description: "we need to revamp our droople site.")

        expect(Project.search_by_title_or_description("word")).to eq([word_press_1])
      end
      it "should return an array of all matches oredered by created_at" do
        word_press_1 = Fabricate(:project, title: "Website", description: "help us make a wordpress site.")
        logo = Fabricate(:project, title: "New Logo", description: "we need help with graphic design work")
        word_press_2 = Fabricate(:project, title: "A website for nonprofit", description: "we need to revamp our droople site.")

        expect(Project.search_by_title_or_description("help")).to eq([word_press_1, logo])
      end
    end

    context "when searching by description and title" do
      it "should return an array of all projects that partially match the search term by title or by description" do
        word_press_1 = Fabricate(:project, title: "Website", description: "help us make a wordpress site.")
        logo_1 = Fabricate(:project, title: "New Logo", description: "we need help with graphic design work on our site")
        word_press_2 = Fabricate(:project, title: "A website for nonprofit", description: "we need to revamp our droople site.")
        logo_2 = Fabricate(:project, title: "For a good cause", description: "we need help with graphic design work on our web")


        expect(Project.search_by_title_or_description("site")).to eq([word_press_1, logo_1, word_press_2])
      end
    end
  end
end