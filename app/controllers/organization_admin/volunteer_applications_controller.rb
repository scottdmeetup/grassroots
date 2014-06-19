class OrganizationAdmin::VolunteerApplicationsController < OrganizationAdminController
  def index
    @open_applications = current_user.volunteer_requests
    render 'conversations/index'
  end
end