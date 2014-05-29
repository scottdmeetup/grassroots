class VolunteerApplicationsController < ApplicationController

  def index
    @volunteer_applications = current_user.volunteer_applications
  end
end