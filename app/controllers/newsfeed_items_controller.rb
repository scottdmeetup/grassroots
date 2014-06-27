class NewsfeedItemsController < ApplicationController
  def index
    @relevent_activity = NewsfeedItem.from_users_followed_by(current_user).sort_by(&:created_at).reverse
  end
end