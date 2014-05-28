class ConversationsController < ApplicationController
  # before_action :find_conversation, :find_message, :find_project, only: [:accept, :completed, :drop]
  def index
    @conversations = current_user.user_conversations
  end

  def show
    @messages = Conversation.find_by(id: params[:id]) 
    @message = PrivateMessage.find_by(conversation_id: @messages.id)
    @private_message = PrivateMessage.new(subject: @message.subject, recipient_id: @message.sender.id, sender_id: current_user.id, conversation_id: @message.conversation_id)
  end

  def accept
    # update_associations_of_freelancers_with_projects(@message.sender_id)

    # project_messages = PrivateMessage.where(project_id: @project.id).to_a
    # disassociate_messages_from_the_project(project_messages)
    # associate_conversations_with_project(project_messages)

    # move_project_status_to_production
    conversation = Conversation.find(params[:conversation_id])
    message = conversation.private_messages.first
    project = Project.find(message.project_id)
    applicant = message.sender_id
    volunteer = User.find(applicant)
    project_messages = PrivateMessage.where(project_id: project.id).to_a
    project_messages.each do |x|
      x.update_attributes!(project_id: nil)
    end  
    project.users.clear
    project.users << [current_user, volunteer]
    project.update_attributes(state: "in production")
    message = project_messages.find {|s| s.conversation_id == conversation.id}
    message.update_attributes(project_id: project.id)
    redirect_to conversation_path(conversation.id)
    flash[:success] = "Please write to the volunteer to let the volunteer know that you have accepted his/her participation on your project"
  end

  def confirm_complete
    conversation = Conversation.find(params[:conversation_id])
    message = conversation.private_messages.first
    project = Project.find(message.project_id)
    project.update_attributes(state: "completed")
    redirect_to conversation_path(conversation.id)
    flash[:success] = "Please write to the volunteer to let the volunteer know that the project is complete"
  end

  def drop
    conversation = Conversation.find(params[:conversation_id])
    message = conversation.private_messages.first
    project = Project.find(message.project_id)
    project.users.clear
    current_user.organization_administrator ? project.users << current_user : project.users << project.project_admin
    project.update_columns(state: "open")
    conversation.private_messages << PrivateMessage.create(subject: message.subject, body: "#{message.sender.first_name} #{message.sender.last_name} has been dropped on this project. This is an automated message." )
    redirect_to conversation_path(conversation.id)
    current_user.organization_administrator ? flash[:success] = "You have dropped this volunteer. Please write to the volunteer to let him/her know." : flash[:success] = "You have dropped this project. Please write to the project administrator to let him/her know." 
  end

private 
  def find_conversation
    @conversation = Conversation.find(params[:conversation_id])
    
  end

  def find_message
    @message = @conversation.private_messages.first
    
  end

  def find_project
    @project = Project.find(@message.project_id)
  end

  def update_associations_of_freelancers_with_projects(applicant_id)
    @project.users.clear
    @project.users << [current_user, freelancer]
    
  end
end