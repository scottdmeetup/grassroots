require 'spec_helper'

describe User do
  it { should belong_to(:organization)}
  it { should belong_to(:project)}
  it { should have_many(:project_users)}
  it { should have_many(:projects).through(:project_users)}
  it { should have_many(:sent_messages)}
  it { should have_many(:received_messages).order("created_at DESC")}

  describe "#private_messages" do
    it "returns all the conversations of the user in an arry" do
      convo = Conversation.create
      bob = Fabricate(:user, first_name: "Bob")
      alice = Fabricate(:user, first_name: "Alice")
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo.id)
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Sounds good. what's your phone number?", conversation_id: convo.id)
      message3 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "my phone number is 123455", conversation_id: convo.id)
      message4 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Great I will call you in a bit", conversation_id: convo.id)

      expect(bob.private_messages).to eq([message1, message2, message3, message4])
    end
  end


  describe "#user_conversations" do
    it "returns a conversation of the user in an arry if there is only one received smessages" do
      convo1 = Conversation.create
      bob = Fabricate(:user, first_name: "Bob")
      alice = Fabricate(:user, first_name: "Alice")
      
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo1.id)
      

      expect(alice.user_conversations).to eq([convo1])
    end

    it "does not return a conversation of the user in an arry if there is only one sent smessages" do
      convo1 = Conversation.create
      bob = Fabricate(:user, first_name: "Bob")
      alice = Fabricate(:user, first_name: "Alice")
      
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo1.id)
      

      expect(bob.user_conversations).to eq([])
    end

    it "returns an array of multiple conversations of the user if there are multiple senders" do
      convo1 = Conversation.create
      convo2 = Conversation.create
      convo3 = Conversation.create
      
      bob = Fabricate(:user, first_name: "Bob")
      alice = Fabricate(:user, first_name: "Alice")
      cat = Fabricate(:user, first_name: "Cat")
      dan = Fabricate(:user, first_name: "Dan")

      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo1.id)
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Sounds good. what's your phone number?", conversation_id: convo1.id)
      message3 = Fabricate(:private_message, recipient_id: alice.id, sender_id: cat.id, subject: "Please let me join your project", body: "I'd really like to help out with your project", conversation_id: convo2.id)
      message4 = Fabricate(:private_message, recipient_id: cat.id, sender_id: alice.id, subject: "Please let me join your project", body: "Let's talk. I think you could be a great asset.", conversation_id: convo2.id)
      message5 = Fabricate(:private_message, recipient_id: alice.id, sender_id: dan.id, subject: "Please let me join your project", body: "I think your project is cool, and I want to help out.", conversation_id: convo3.id)

      expect(alice.user_conversations).to eq([convo1, convo2, convo3])
    end

    it "does not return duplicate conversations" do
      convo1 = Conversation.create

      bob = Fabricate(:user, first_name: "Bob")
      alice = Fabricate(:user, first_name: "Alice")

      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", conversation_id: convo1.id)
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, subject: "Please let me join your project", body: "Sounds good. what's your phone number?", conversation_id: convo1.id)
      message3 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd really like to help out with your project", conversation_id: convo1.id)
      

      expect(alice.user_conversations).to eq([convo1])
    end
  end

  describe "#organization_name" do
    it "returns the name of the organization of the user" do
      bob = Fabricate(:user, first_name: "Bob")
      org = Fabricate(:organization)
      bob.update(organization_id: 1)

      expect(bob.organization_name).to eq(org.name)
    end
  end
end
  