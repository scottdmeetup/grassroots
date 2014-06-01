require 'spec_helper'

describe Conversation do
  it {should have_many(:private_messages).order("created_at ASC")}

  describe "#sender_user_name_of_recent_message" do
    it "returns the name of the sender of the most recent message" do
      convo = Conversation.create
      bob = Fabricate(:user, first_name: "Bob", last_name: "Smith", user_group: "volunteer")
      alice = Fabricate(:user, first_name: "Alice", last_name: "Smith", user_group: "nonprofit")
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo.id)
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Sounds good. what's your phone number?", conversation_id: convo.id)
      message3 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "my phone number is 123455", conversation_id: convo.id)
      message4 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Great I will call you in a bit", conversation_id: convo.id)

      expect(convo.sender_user_name_of_recent_message).to eq("Alice Smith")
    end
  end

  describe "#the_id_of_sender" do
    it "returns the sender's id of the conversation's most recent private message " do
      convo = Conversation.create
      bob = Fabricate(:user, first_name: "Bob", last_name: "Smith", user_group: "volunteer")
      alice = Fabricate(:user, first_name: "Alice", last_name: "Smith", user_group: "nonprofit")
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo.id)
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Sounds good. what's your phone number?", conversation_id: convo.id)
      message3 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "my phone number is 123455", conversation_id: convo.id)
      message4 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Great I will call you in a bit", conversation_id: convo.id)

      expect(convo.the_id_of_sender).to eq(alice.id)
    end
  end

  describe "#private_message_subject" do
    it "returns the subject of the conversation's most recent private message" do
      convo = Conversation.create
      bob = Fabricate(:user, first_name: "Bob", last_name: "Smith", user_group: "volunteer")
      alice = Fabricate(:user, first_name: "Alice", last_name: "Smith", user_group: "nonprofit")
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo.id)
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Sounds good. what's your phone number?", conversation_id: convo.id)
      message3 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "my phone number is 123455", conversation_id: convo.id)
      message4 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Great I will call you in a bit", conversation_id: convo.id)

      expect(convo.private_message_subject).to eq(message4.subject)
    end
  end

  describe "#private_message_body" do
    it "returns an abridged body of the conversation's private message" do
      convo = Conversation.create
      bob = Fabricate(:user, first_name: "Bob", last_name: "Smith", user_group: "volunteer")
      alice = Fabricate(:user, first_name: "Alice", last_name: "Smith", user_group: "nonprofit")
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo.id)
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Sounds good. what's your phone number?", conversation_id: convo.id)
      message3 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "my phone number is 123455", conversation_id: convo.id)
      message4 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Great I will call you in a bit", conversation_id: convo.id)

      expect(convo.private_message_body).to eq(message4.body)
    end
  end

  describe "#with_work_submitted" do
    it "returns true if a private message seeks to complete a project" do
      convo = Conversation.create
      bob = Fabricate(:user, first_name: "Bob", last_name: "Smith", user_group: "volunteer")
      alice = Fabricate(:user, first_name: "Alice", last_name: "Smith", user_group: "nonprofit")
      huggey_bear = Fabricate(:organization, user_id: alice.id)
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "pending completion")
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Project complete", body: "this project is done", conversation_id: convo.id)
      contract = Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: true, project_id: huggey_bear.id, work_submitted: true)
      convo.update_columns(contract_id: contract.id)

      expect(convo.with_work_submitted).to eq(true)
    end
  end

  describe "#with_opportunity_to_drop_job" do
    it "returns true if the conversation has a contract that is only active" do
      convo = Conversation.create
      bob = Fabricate(:user, first_name: "Bob", last_name: "Smith", user_group: "volunteer")
      alice = Fabricate(:user, first_name: "Alice", last_name: "Smith", user_group: "nonprofit")
      huggey_bear = Fabricate(:organization, user_id: alice.id)
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "pending completion")
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Project complete", body: "this project is done", conversation_id: convo.id)
      contract = Fabricate(:contract, contractor_id: alice.id, volunteer_id: bob.id, active: true, project_id: huggey_bear.id, work_submitted: nil)
      convo.update_columns(contract_id: contract.id)      

      expect(convo.with_opportunity_to_drop_job).to eq(true)
    end
  end
end