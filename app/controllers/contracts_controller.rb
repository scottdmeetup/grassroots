class ContractsController < ApplicationController
  before_action :find_volunteer_application, only: [:create]
  before_action :find_contract, only: [:submit_work_message_form]
  def new
    contract = Contract.find(params[:contract_id])
    @project = Project.find(contract.project_id)
    @private_message = PrivateMessage.new(recipient_id: @project.project_admin.id, subject: "Please Review Work: #{@project.title}")
  end

  def create
    accept_application_and_project_in_production(@volunteer_application)
    reject_other_applications(@volunteer_application)
    create_contract_and_associate_it_with_conversation_which_triggers_drop_opportunity(@volunteer_application)
  end

  def dropping_contract 
    send_automated_message
    contract_drops_and_project_becomes_open(@contract)
  end

  def update_contract_work_submitted
    creates_new_conversation_about_work_submission_and_updates_contract
    opportunity_to_drop_project_is_removed(@contract, @first_message)
  end

  def contract_complete
    find_conversation_and_update_contract_associated_with_it
  end

  def submit_work_message_form
    @private_message = PrivateMessage.new(recipient_id: @contract.contractor_id)
  end

private

  def message_params
    params.require(:private_message).permit(:subject, :sender_id, :recipient_id, :body)
  end

  def find_volunteer_application
    @volunteer_application = VolunteerApplication.find(params[:volunteer_application_id])
  end

  def find_contract
    @contract = Contract.find(params[:contract_id])
  end

  def accept_application_and_project_in_production(application)
    application.update_columns(accepted: true, rejected: false)
    project = Project.find(application.project_id)
    project.update_columns(state: nil)
  end

  def reject_other_applications(accepted_application)
    rejected_applications = VolunteerApplication.where(accepted: nil, rejected: nil, project_id: accepted_application.project_id).to_a
    rejected_applications.each do |member|
       member.update_columns(accepted: false, rejected: true)
    end 
  end

  def create_contract_and_associate_it_with_conversation_which_triggers_drop_opportunity(accepted_application)
    conversation = Conversation.find_by(params[:conversation_id])
    volunteer = User.find(accepted_application.applicant_id)
    contract = Contract.create(active: true, contractor_id: current_user.id, volunteer_id: volunteer.id, project_id: accepted_application.project_id)
    conversation.update_columns(contract_id: contract.id, volunteer_application_id: nil)
    redirect_to conversation_path(conversation.id)
  end

  def send_automated_message
    @contract = Contract.find(params[:id])
    @conversation = Conversation.find_by(contract_id: @contract.id)
    first_message = @conversation.private_messages.first
    @conversation.private_messages << PrivateMessage.create(subject: first_message.subject, body: "#{first_message.sender.first_name} #{first_message.sender.last_name} has been dropped on this project. This is an automated message." )
  end

  def contract_drops_and_project_becomes_open(contract)
    @contract.update!(active: nil, volunteer_id: nil, dropped_out: true, active: false)
    project = Project.find(contract.project_id)
    project.update_columns(state: "open")
    redirect_to conversation_path(@conversation.id)
  end

  def creates_new_conversation_about_work_submission_and_updates_contract
    conversation_about_work_submission = Conversation.create
    @first_message = PrivateMessage.new(message_params.merge!(conversation_id: conversation_about_work_submission.id))
    @first_message.save
    @contract = Contract.find(params[:id])
    conversation_about_work_submission.update_columns(contract_id: @contract.id)
    @contract.update_columns(work_submitted: true, complete: nil, active: true)
  end

  def opportunity_to_drop_project_is_removed(contract, first_message)
    previous_conversation_loses_drop_opportunity = Conversation.where(contract_id: contract.id).first
    previous_conversation_loses_drop_opportunity.update_columns(contract_id: nil)
    flash[:success] = "Your message has been sent to #{first_message.recipient.first_name} #{first_message.recipient.last_name}"
    redirect_to conversations_path
  end

  def find_conversation_and_update_contract_associated_with_it
    contract = Contract.find(params[:id])
    complete_work_conversation = Conversation.find_by(contract_id: contract.id)
    contract.update_columns(complete: true, active: false, incomplete: false, work_submitted: true )
    redirect_to conversation_path(complete_work_conversation.id)
  end
end