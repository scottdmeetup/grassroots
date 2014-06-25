class RelationshipsController < ApplicationController
  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if relationship.follower == current_user
    redirect_to :back
  end
end