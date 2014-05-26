require 'spec_helper'

describe Conversation do
  it {should have_many(:private_messages).order("created_at ASC")}

  describe "#sender_user_name_of_recent_message" do
    it "returns the name of the sender of the most recent message" do
      convo = Conversation.create
      bob = Fabricate(:user, first_name: "Bob", last_name: "Smith")
      alice = Fabricate(:user, first_name: "Alice", last_name: "Smith")
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
      bob = Fabricate(:user, first_name: "Bob", last_name: "Smith")
      alice = Fabricate(:user, first_name: "Alice", last_name: "Smith")
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
      bob = Fabricate(:user, first_name: "Bob", last_name: "Smith")
      alice = Fabricate(:user, first_name: "Alice", last_name: "Smith")
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
      bob = Fabricate(:user, first_name: "Bob", last_name: "Smith")
      alice = Fabricate(:user, first_name: "Alice", last_name: "Smith")
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo.id)
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Sounds good. what's your phone number?", conversation_id: convo.id)
      message3 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "my phone number is 123455", conversation_id: convo.id)
      message4 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Great I will call you in a bit", conversation_id: convo.id)

      expect(convo.private_message_body).to eq(message4.body)
    end
  end

  describe "#join_request" do
    it "returns true if a private message requests to join a project" do
      convo = Conversation.create
      alice = Fabricate(:user, first_name: "Alice", last_name: "Smith")
      bob = Fabricate(:user, first_name: "Bob", last_name: "Smith")
      huggey_bear = Fabricate(:organization, user_id: alice.id)
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open")
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo.id, project_id: word_press.id)
      bob.projects << word_press
      alice.projects << word_press

      expect(convo.join_request).to eq(true)
    end
  end

  describe "#project_complete_request" do
    it "returns true if a private message seeks to complete a project" do
      convo = Conversation.create
      alice = Fabricate(:user, first_name: "Alice", last_name: "Smith")
      bob = Fabricate(:user, first_name: "Bob", last_name: "Smith")
      huggey_bear = Fabricate(:organization, user_id: alice.id)
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "pending completion")
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Project complete", body: "this project is done", conversation_id: convo.id, project_id: word_press.id)
      bob.projects << word_press
      alice.projects << word_press

      expect(convo.project_complete_request).to eq(true)
    end
  end

  describe "#opportunity_drop_project" do
    it "returns true if a private message is part of a project in production" do
      convo = Conversation.create
      alice = Fabricate(:user, first_name: "Alice", last_name: "Smith")
      bob = Fabricate(:user, first_name: "Bob", last_name: "Smith")
      huggey_bear = Fabricate(:organization, user_id: alice.id)
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open")
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo.id, project_id: word_press.id)
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Project let me join your project", body: "your request has been accepted", conversation_id: convo.id, project_id: word_press.id)
      word_press.update_attributes(state: "in production")
      bob.projects << word_press
      alice.projects << word_press

      expect(convo.opportunity_drop_project).to eq(true)
    end

    it "true if the project has changed from open to in production" do
      convo = Conversation.create
      alice = Fabricate(:user, first_name: "Alice", last_name: "Smith")
      bob = Fabricate(:user, first_name: "Bob", last_name: "Smith")
      huggey_bear = Fabricate(:organization, user_id: alice.id)
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open")
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo.id, project_id: word_press.id)
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Project let me join your project", body: "your request has been accepted", conversation_id: convo.id, project_id: word_press.id)
      word_press.update_columns(state: "in production")
      bob.projects << word_press
      alice.projects << word_press

      expect(convo.opportunity_drop_project).to eq(true)
    end
=begin
    it "returns false if the, in production, state of project is at more than 5 days old" do
      convo = Conversation.create
      alice = Fabricate(:user, first_name: "Alice", last_name: "Smith")
      bob = Fabricate(:user, first_name: "Bob", last_name: "Smith")
      huggey_bear = Fabricate(:organization, user_id: alice.id)
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id, state: "open", created_at: 10.days.ago)
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo.id, project_id: word_press.id)
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Project let me join your project", body: "your request has been accepted", conversation_id: convo.id, project_id: word_press.id)
      word_press.update_attributes!(state: "in production", updated_at: 6.days.ago)
      bob.projects << word_press
      alice.projects << word_press

      expect(convo.reload.opportunity_drop_project).to eq(false)
    end
=end
  end
end