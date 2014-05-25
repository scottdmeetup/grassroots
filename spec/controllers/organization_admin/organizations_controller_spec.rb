require 'spec_helper'

describe OrganizationAdmin::OrganizationsController, :type => :controller do
  describe "GET edit" do
    it "renders a form for the current user to edit the organization's profile" do
      huggey_bear = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization_id: huggey_bear.id)
      set_current_user(alice)
      get :edit, id: huggey_bear.id

      expect(response).to render_template(:edit)
    end
    it "sets the @organization" do
      huggey_bear = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization_id: huggey_bear.id)
      set_current_user(alice)
      get :edit, id: huggey_bear.id

      expect(assigns(:organization)).to eq(huggey_bear)
    end
  end
  
  describe "PATCH update" do
    it "redirects to the organization's profile page" do
      huggey_bear = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization_id: huggey_bear.id)
      set_current_user(alice)
      patch :update, id: huggey_bear.id, organization: Fabricate.attributes_for(:organization)

      expect(response).to redirect_to(organization_path(Organization.first.id))
    end
    it "updates the user's information" do
      huggey_bear = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization_id: huggey_bear.id)
      set_current_user(alice)
      patch :update, id: huggey_bear.id, organization: Fabricate.attributes_for(:organization, goal: "test 123")

      expect(huggey_bear.reload.goal).to eq("test 123")

    end
    it "flashes a notice that the user updated his/her profile" do
      huggey_bear = Fabricate(:organization)
      alice = Fabricate(:organization_administrator, organization_id: huggey_bear.id)
      set_current_user(alice)
      patch :update, id: huggey_bear.id, organization: Fabricate.attributes_for(:organization, goal: "test 123")

      expect(flash[:notice]).to eq("You have updated your organization's profile.")
    end
  end
end