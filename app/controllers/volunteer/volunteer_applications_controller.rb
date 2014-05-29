class Volunteer::VolunteerApplicationsController < VolunteerController
  def index
    @open_applications = current_user.sent_applications
    render 'conversations/index'
  end
end