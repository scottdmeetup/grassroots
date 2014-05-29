class OrganizationAdmin::VolunteerApplicationsController < OrganizationAdminController
  def index
    @open_volunteer_applicatinos = current_user.volunteer_applications.where(accepted: nil, rejected: nil, administrator_id: current_user.id).to_a
    render 'conversations/index'
  end
end