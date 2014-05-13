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
end