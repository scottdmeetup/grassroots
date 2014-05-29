class OrganizationAdmin::VolunteerApplicationsController < OrganizationAdminController
  def index
    @open_applications = current_user.received_applications
    render 'conversations/index'
  end
end