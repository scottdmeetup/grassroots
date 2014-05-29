class VolunteerController < ApplicationController
  before_filter :ensure_volunteer

  def ensure_volunteer
    redirect_to user_path(current_user.id) unless current_user.user_group == "volunteer"
  end
end