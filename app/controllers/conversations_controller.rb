class ConversationsController < ApplicationController
  
  def index
    
    @conversations = current_user.user_conversations
  end

  def show
    @conversation = Conversation.find(params[:id]) 
    @first_message = @conversation.private_messages.first
    @reply = PrivateMessage.new(subject: @first_message.subject, recipient_id: @first_message.sender.id, sender_id: current_user.id, conversation_id: @first_message.conversation_id)
  end
=begin
  def accept
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
=end

end