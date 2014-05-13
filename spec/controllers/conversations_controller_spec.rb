require 'spec_helper'

describe ConversationsController do
    let(:alice) { Fabricate(:user, first_name: "Alice") }
    let(:bob) { Fabricate(:user, first_name: "Bob") }
    let(:cat) { Fabricate(:user, first_name: "Cat") }
    
    before do
      session[:user_id] = alice.id
    end

  describe "GET index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
    
    it "shows a conversation if current user receives a sent message" do
      conversation1 = Fabricate(:conversation)
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "OK great. when can you start?") 
      #message3 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'll call you. What's your number?.") 
      get :index

      expect(alice.user_conversations).to match_array([conversation1])
    end

    it "sets the @conversations" do
      get :index

      expect(assigns(:conversations)).to eq(alice.user_conversations)
    end
  end
  
  describe "GET show" do
    it "it renders the show template" do
      conversation1 = Fabricate(:conversation)
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "OK great. when can you start?") 
      get :show, id: conversation1.id

      expect(response).to render_template(:show)
    end
    it "sets the @messages" do
      conversation1 = Fabricate(:conversation)
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "OK great. when can you start?") 
      get :show, id: conversation1.id

      expect(assigns(:messages)).to be_instance_of(Conversation)
    end

    it "shows a received private message" do
      conversation1 = Fabricate(:conversation)
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
      get :show, id: conversation1.id
      expect(conversation1.private_messages).to eq([message1])
    end

    it "shows the private messages of the conversation" do
      conversation1 = Fabricate(:conversation)
      message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
      message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "OK great. when can you start?") 
      get :show, id: conversation1.id

      expect(conversation1.private_messages).to eq([message1, message2])
    end

    context "when replying to a message" do

      it "sets the @private_message to new" do
        conversation1 = Fabricate(:conversation)
        message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
        get :show, id: conversation1.id

        expect(assigns(:private_message)).to be_a PrivateMessage
      end

      it "sets the recipient value" do
        conversation1 = Fabricate(:conversation)
        message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
        get :show, id: conversation1.id

        expect(assigns(:private_message).recipient).to eq(bob)
      end
      it "sets the sender value" do
        conversation1 = Fabricate(:conversation)
        message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
        get :show, id: conversation1.id

        expect(assigns(:private_message).sender).to eq(alice)
      end
      it "sets the subject line with the value of the message title with Project Request: the message's title" do
        conversation1 = Fabricate(:conversation)
        message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
        get :show, id: conversation1.id

        expect(assigns(:private_message).subject).to eq("Please let me join your project")
      end

      it "sets the conversation id of the sent message" do
        conversation1 = Fabricate(:conversation)
        message1 = Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")
        message2 = Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "OK great. when can you start?") 
        get :show, id: conversation1.id

        expect(assigns(:private_message).conversation).to eq(conversation1)
      end
      
      it "shows the conversation between the sender and the recipient"
      context "when its a join request" 
        it "shows a an option to accept the join request"
        it "shows an option to reject the join request"
        it "shows an option to reply to the private message"
      ##when a join request is accepted, all other join requests are rejected
    end
  end
end

#let(:bob_message2) {Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I think you would fit in well. Let's talk.")}
    #let(:bob_message3) {Fabricate(:private_message, recipient_id: alice.id, sender_id: bob.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "OK great. when can I reach out to you?")}
    #let(:bob_message4) {Fabricate(:private_message, recipient_id: bob.id, sender_id: alice.id, conversation_id: conversation1.id, subject: "Please let me join your project", body: "I'll call you. What's your number?.")}

    #let(:conversation2) {Fabricate(:conversation)}
    #let(:cat_message1) {Fabricate(:private_message, recipient_id: alice.id, sender_id: cat.id, conversation_id: conversation2.id, subject: "Please let me join your project", body: "I'd like to contribute to your project")}
    #let(:cat_message2) {Fabricate(:private_message, recipient_id: cat.id, sender_id: alice.id, conversation_id: conversation2.id, subject: "Please let me join your project", body: "I think you would fit in well. Let's talk.")}
    #let(:cat_message3) {Fabricate(:private_message, recipient_id: alice.id, sender_id: cat.id, conversation_id: conversation2.id, subject: "Please let me join your project", body: "OK great. when can I reach out to you?")}
    #let(:cat_message4) {Fabricate(:private_message, recipient_id: cat.id, sender_id: alice.id, conversation_id: conversation2.id, subject: "Please let me join your project", body: "I'll call you. What's your number?.")}