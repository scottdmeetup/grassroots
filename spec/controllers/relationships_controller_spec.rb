require 'spec_helper'

describe RelationshipsController, :type => :controller do
  let!(:alice) {Fabricate(:user, user_group: "nonprofit")}
  let!(:bob) {Fabricate(:user, user_group: "volunteer")}

  before(:each) do  
    set_current_user(alice)
    request.env["HTTP_REFERER"] = "/users/2" unless request.nil? or request.env.nil?
  end

  describe "DELETE destroy" do
    it "deletes the relationship if the current user is the follower" do
      relationship = Relationship.create(follower: alice, leader: bob)
      delete :destroy, id: relationship

      expect(Relationship.count).to eq(0)
    end
    it "redirects back to the page wherever the user unfollows" do
      relationship = Relationship.create(follower: alice, leader: bob)
      delete :destroy, id: relationship

      expect(response).to redirect_to(user_path(bob.id))
    end

    it "does not delete the relationship if the current user is not the follower" do
      catherine = Fabricate(:user, user_group: "volunteer")
      relationship = Relationship.create(follower: catherine, leader: bob)
      delete :destroy, id: relationship

      expect(Relationship.count).to eq(1)
    end
  end

  describe "POST create" do

    let!(:alice) {Fabricate(:user, user_group: "nonprofit")}
    let!(:bob) {Fabricate(:user, user_group: "volunteer")}

    before(:each) do  
      set_current_user(alice)
      request.env["HTTP_REFERER"] = "/users/2" unless request.nil? or request.env.nil?
    end

    it "redirects back to the page where the user posted the request" do
      post :create, leader_id: bob.id

      expect(response).to redirect_to(user_path(bob.id))
    end

    it "creates a relationship that the current user follows the leader" do
      post :create, leader_id: bob.id

      expect(alice.following_relationships.first.leader).to eq(bob)
    end
    it "does not create a relationship if the current user already follows the leader" do
      relationship = Relationship.create(follower: alice, leader: bob)
      post :create, leader_id: bob.id

      expect(Relationship.count).to eq(1)
    end
    it "does not allow one to follow themselves" do
      post :create, leader_id: alice.id

      expect(Relationship.count).to eq(0)
    end
  end
end