class VolunteerApplicationsController < ApplicationController

  def index
    if current_user.user_group == "nonprofit"
      @open_volunteer_applications = current_user.volunteer_applications.where(accepted: nil, rejected: nil, applicant_id: current_user.id)
    else
      @open_volunteer_applications = current_user.volunteers_open_applications
    end
  end
end