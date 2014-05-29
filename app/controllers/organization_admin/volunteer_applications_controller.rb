class OrganizationAdmin::VolunteerApplicationsController < OrganizationAdminController
  def index
    binding.pry
    @open_volunteer_applicatinos = current_user.received_applications.to_a
    render 'conversations/index'
  end
end