class ContractsController < ApplicationController
  def new
    contract = Contract.find(params[:contract_id])
    @project = Project.find(contract.project_id)
    @private_message = PrivateMessage.new(recipient_id: @project.project_admin.id, subject: "Please Review Work: #{@project.title}")
  end

  def create
    volunteer_application = VolunteerApplication.find(params[:volunteer_application_id])
    volunteer_application.update_columns(accepted: true, rejected: false)
    project = Project.find(volunteer_application.project_id)
    project.update_columns(state: nil)
    rejected_applications = VolunteerApplication.where(accepted: nil, rejected: nil, project_id: volunteer_application.project_id).to_a
    rejected_applications.each do |member|
       member.update_columns(accepted: false, rejected: true)
    end 
    conversation = Conversation.find_by(params[:conversation_id])
    volunteer = User.find(volunteer_application.applicant_id)
    contract = Contract.create(active: true, contractor_id: current_user.id, volunteer_id: volunteer.id, project_id: volunteer_application.project_id)
    conversation.update_columns(contract_id: contract.id, volunteer_application_id: nil)
    redirect_to conversation_path(conversation.id)
  end

  def dropping_contract
    contract = Contract.find(params[:id])
    conversation = Conversation.find_by(contract_id: contract.id)
    contract.update_columns(dropped_out: true, active: false)
    first_message = conversation.private_messages.first
    conversation.private_messages << PrivateMessage.create(subject: first_message.subject, body: "#{first_message.sender.first_name} #{first_message.sender.last_name} has been dropped on this project. This is an automated message." )
    contract.contract_dropped
    redirect_to conversation_path(conversation.id)
  end

  def update_contract_work_submitted
    contract = Contract.find(params[:id])
    conversation_about_submitted_work = Conversation.create(contract_id: contract.id)
    first_message = PrivateMessage.new(message_params.merge!(conversation_id: conversation_about_submitted_work.id))
    first_message.save
    contract.update_columns(work_submitted: true)
    redirect_to conversations_path
  end

  def contract_complete
    contract = Contract.find(params[:id])
    complete_work_conversation = Conversation.find_by(contract_id: contract.id)
    contract.update_columns(complete: true, active: false, incomplete: false, work_submitted: true )
    redirect_to conversation_path(complete_work_conversation.id)
  end
private

  def message_params
    params.require(:private_message).permit(:subject, :sender_id, :recipient_id, :body)
  end
end