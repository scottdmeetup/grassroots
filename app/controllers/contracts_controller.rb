class ContractsController < ApplicationController

  def create
    volunteer_application = VolunteerApplication.find(params[:volunteer_application_id])
    volunteer_application.update_columns(accepted: true, rejected: false)
    rejected_applications = VolunteerApplication.where(accepted: nil, rejected: nil).to_a
    rejected_applications.each do |member|
       member.update_columns(accepted: false, rejected: true)
    end 
    conversation = Conversation.find_by(params[:conversation_id])
    contract = Contract.create
    contract.update_columns(active: true, contractor_id: current_user.id, volunteer_id: volunteer_application.applicant_id, project_id: volunteer_application.project_id)
    redirect_to conversation_path(conversation.id)
  end
end