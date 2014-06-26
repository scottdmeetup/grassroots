class RelationshipsController < ApplicationController
  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if relationship.follower == current_user
    redirect_to :back
  end

  def create
    leader = User.find(params[:leader_id])
    Relationship.create(leader_id: params[:leader_id], follower: current_user) if current_user.can_follow?(leader)
    redirect_to :back
  end
end