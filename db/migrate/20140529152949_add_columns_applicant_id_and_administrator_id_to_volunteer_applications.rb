class AddColumnsApplicantIdAndAdministratorIdToVolunteerApplications < ActiveRecord::Migration
  def change
    add_column :volunteer_applications, :applicant_id, :integer
    add_column :volunteer_applications, :administrator_id, :integer
  end
end
