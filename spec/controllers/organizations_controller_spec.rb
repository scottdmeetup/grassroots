require 'spec_helper'

describe OrganizationsController, :type => :controller do
  describe "GET show" do
    it "renders the organization show template" do
      amnesty = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization_id: amnesty.id, user_group: "nonprofit")
      amnesty.update_columns(user_id: alice.id)
      get :show, id: amnesty

      expect(response).to render_template(:show)
    end
    it "shows the organization's profile" do
      amnesty = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization_id: amnesty.id, user_group: "nonprofit")
      amnesty.update_columns(user_id: alice.id)
      get :show, id: amnesty.id

      expect(assigns(:organization)).to eq(amnesty)
    end
  end

  describe "GET index" do
    it "renders the organization show template" do
      get :index

      expect(response).to render_template(:index)
    end

    it "sets the @organiziations" do
      amnesty = Fabricate(:organization)
      global = Fabricate(:organization)
      huggey_bears = Fabricate(:organization)
      get :index

      expect(assigns(:organizations)).to eq([amnesty, global, huggey_bears])
    end
  end

  describe "GET search" do
    let!(:huggey_bear) {Fabricate(:organization, name: "Huggey Bear Land", cause: "Animal Rights", 
      ruling_year: 1998, mission_statement: "We want to give everyone a huggey bear in their sad times", 
      guidestar_membership: nil, ein: "192512653-6", street1: "2998 Hansen Heights", 
      street2: nil, city: "New York", state_abbreviation: 0, zip: "28200-1366", 
      ntee_major_category_id: 0, funding_method: nil, user_id: nil,budget: "$22,000,000.00", 
      contact_number: "555-555-5555", contact_email: "test@example.com", 
      goal: "We want 1 out of every 5 Americans to have a huggey bear.")}

    let!(:amnesty) {Fabricate(:organization, name: "Amnesty International", cause: "Human Rights", 
      ruling_year: 1912, mission_statement: "We want to see human rights spread across the globe -- chyea.", 
      guidestar_membership: nil, ein: "987931299-1", street1: "3293 Dunnit Hill", 
      street2: nil, city: "New York", state_abbreviation: 0, zip: "28200-1366", ntee_major_category_id: 0, 
      funding_method: nil, user_id: nil, budget: "$22,000,000.00", contact_number: "555-555-5555", 
      contact_email: "test@example.com", goal: "Every year we want at least one thousand human rights activists released from prisons around the world.")}

    let!(:global_giving) {Fabricate(:organization, name: "Global Giving", cause: "Social Good", ruling_year: 2000, 
      mission_statement: "We make it rain on Nonprofits, erreday", guidestar_membership: nil, 
      ein: "222222222-2", street1: "2222 Rick Ross", street2: nil, city: "DC", 
      state_id: 0, zip: "28200-1366", ntee_major_category_id: 0, funding_method: nil, user_id: nil,
      budget: "$22,000,000.00", contact_number: "555-555-5555", contact_email: "test@example.com",
      goal: "We want each of our nonprofit partners to raise at least $ 5,000.00 from our platform a year.")}

    let!(:the_bears) {Fabricate(:organization, name: "The Bears")}

    let!(:boys_girls) {Fabricate(:organization, name: "Boys and Girls Club Of America", cause: "Youth Education")}

    let!(:red_cross) {Fabricate(:organization, name: "Red Cross", cause: "Human Rights")}

    context "when only using the checkbox filters" do
      it "redirects to the results page" do
        get :search

        expect(response).to render_template(:search)
      end

      it "shows the users under a certain cause" do
        get :search, cause: "Human Rights"

        expect(assigns(:results)).to eq([amnesty, red_cross])
      end

    end
    context "when using the search bar" do
      it "sets the @results variable by search term" do
        get :search, search_term: "bear"

        expect(assigns(:results)).to eq([huggey_bear, the_bears])
      end
      it "redirects to the results page" do
        get :search, search_term: "bear"

        expect(response).to render_template(:search)
      end
    end
  end
end