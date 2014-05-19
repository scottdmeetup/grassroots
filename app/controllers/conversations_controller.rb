class ConversationsController < ApplicationController
  def index
    @conversations = current_user.user_conversations
  end

  def show
    @messages = Conversation.find_by(id: params[:id]) 
    @message = PrivateMessage.find_by(conversation_id: @messages.id)
    @private_message = PrivateMessage.new(subject: @message.subject, recipient_id: @message.sender.id, sender_id: current_user.id, conversation_id: @message.conversation_id)
  end

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
    redirect_to conversation_path(conversation.id)
    flash[:success] = "Please write to the volunteer to let the volunteer know that you have accepted his/her participation on your project"
  end

  def completed
    conversation = Conversation.find(params[:conversation_id])
    message = conversation.private_messages.first
    project = Project.find(message.project_id)
    project.update_attributes(state: "completed")
    redirect_to conversation_path(conversation.id)
    flash[:success] = "Please write to the volunteer to let the volunteer know that the project is complete"
  end
end