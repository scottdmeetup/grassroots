require 'spec_helper'


describe PrivateMessagesController do
  describe "GET new" do
    it "renders the new template for creating a private message" do
      alice = Fabricate(:organization_administrator, organization_id: nil)
      huggey_bear = Fabricate(:organization, user_id: alice.id)
      alice.update_columns(organization_id: huggey_bear.id)
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id)

      get :new, project_id: word_press.id
      expect(response).to render_template(:new)
    end
    it "sets @private_message" do
      alice = Fabricate(:organization_administrator, organization_id: nil)
      huggey_bear = Fabricate(:organization, user_id: alice.id)
      alice.update_columns(organization_id: huggey_bear.id)
      word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id)

      get :new, project_id: word_press.id
      expect(assigns(:private_message)).to be_instance_of(PrivateMessage)
    end
    
    context "when sending a join request" do
      it "sets the @project.id" do
        alice = Fabricate(:organization_administrator, organization_id: nil)
        huggey_bear = Fabricate(:organization, user_id: alice.id)
        alice.update_columns(organization_id: huggey_bear.id)
        word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id)

        get :new, project_id: word_press.id
        expect(assigns(:private_message).project_id).to eq(1)
      end
      it "sets the recipient value" do
        alice = Fabricate(:organization_administrator, organization_id: nil)
        huggey_bear = Fabricate(:organization, user_id: alice.id)
        alice.update_columns(organization_id: huggey_bear.id)
        word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id)

        get :new, project_id: word_press.id
        expect(assigns(:private_message).recipient).to eq(alice)
      end
      it "sets the subject line with the value of the project title with Project Request:" do
        alice = Fabricate(:organization_administrator, organization_id: nil)
        huggey_bear = Fabricate(:organization, user_id: alice.id)
        alice.update_columns(organization_id: huggey_bear.id)
        word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id)

        get :new, project_id: word_press.id
        expect(assigns(:private_message).subject).to eq("Project Request: word press website")
      end
    end
  end

  describe "POST create" do
    context "with valid input" do
      context "when requesting to join a project" do
        it "changes the project's state from open to pending" do
          alice = Fabricate(:organization_administrator, organization_id: nil)
          bob = Fabricate(:user)
          huggey_bear = Fabricate(:organization, user_id: alice.id)
          alice.update_columns(organization_id: huggey_bear.id)
          word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id)
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id}

          word_press = Project.first
          expect(word_press.state).to eq('pending')
        end
        it "changes the project’s state from open to pending on the freelancers dashboard" do
          alice = Fabricate(:organization_administrator, organization_id: nil)
          bob = Fabricate(:user)
          huggey_bear = Fabricate(:organization, user_id: alice.id)
          alice.update_columns(organization_id: huggey_bear.id)
          word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id)
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id}

          expect(word_press.reload.state).to eq('pending')
        end
        
        it "changes the project’s state from open to pending on the organization admin's dashboard" do
          alice = Fabricate(:organization_administrator, organization_id: nil)
          bob = Fabricate(:user)
          huggey_bear = Fabricate(:organization, user_id: alice.id)
          alice.update_columns(organization_id: huggey_bear.id)
          word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id)
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id}

          word_press = Project.where(user_id: alice.id).first
          expect(word_press.state).to eq('pending')
        end
        it "changes the project’s state from open to pending on the organization's board" do
          alice = Fabricate(:organization_administrator, organization_id: nil)
          bob = Fabricate(:user)
          huggey_bear = Fabricate(:organization, user_id: alice.id)
          alice.update_columns(organization_id: huggey_bear.id)
          word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id)
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id}

          word_press = Project.where(organization_id: huggey_bear.id).first
          expect(word_press.state).to eq('pending')
        end
        it "makes the organization admin receive a private message from the freelancer" do
          alice = Fabricate(:organization_administrator, organization_id: nil)
          bob = Fabricate(:user)
          huggey_bear = Fabricate(:organization, user_id: alice.id)
          alice.update_columns(organization_id: huggey_bear.id)
          word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id)
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id}

          message = PrivateMessage.first
          expect(alice.received_messages).to eq([message])
        end
        
        it "stores the private message in the freelancer's index of sent private messages" do
          alice = Fabricate(:organization_administrator, organization_id: nil)
          bob = Fabricate(:user)
          huggey_bear = Fabricate(:organization, user_id: alice.id)
          alice.update_columns(organization_id: huggey_bear.id)
          word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id)
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id}

          message = PrivateMessage.first
          expect(bob.sent_messages).to eq([message])
        end

        it "flash's a success notice that your join request has been sent" do
          alice = Fabricate(:organization_administrator, organization_id: nil)
          bob = Fabricate(:user)
          huggey_bear = Fabricate(:organization, user_id: alice.id)
          alice.update_columns(organization_id: huggey_bear.id)
          word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id)
          post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, subject: "Please let me join your project", body: "I'd like to contribute to your project", project_id: word_press.id}

          expect(flash[:success]).to eq("Your join request has been sent.")
        end
        it "adds the freelancer's thumbnail photo to the project's details"
        it "remains open on the project index"
        it "triggers a private message alert on the recipient's notification icon"
        it "notifies the organization admin that a user wants to join his/her project"
        it "sends out an email to the recipient notifying him/her"
      end
    end
    context "with invalid input" do
      it "renders the new template" do
        alice = Fabricate(:organization_administrator, organization_id: nil)
        bob = Fabricate(:user)
        huggey_bear = Fabricate(:organization, user_id: alice.id)
        alice.update_columns(organization_id: huggey_bear.id)
        word_press = Fabricate(:project, title: "word press website", user_id: alice.id, organization_id: huggey_bear.id)
        post :create, private_message: {recipient_id: alice.id, sender_id: bob.id, body: "I'd like to contribute to your project", project_id: word_press.id}

        expect(response).to render_template("new")
      end
    end
  end

  describe "GET index" do
  end

  describe "GET show" do
    it "renders the show template for a private message"
    it "shows a received private message"
    it "shows the reply button"
    it "redirects the user to a new conversation if the user clicks reply"
    it "shows the conversation between the sender and the recipient"
    context "when its a join request"
      it "shows a an option to accept the join request"
      it "shows an option to reject the join request"
      it "shows an option to reply to the private message"
      ##when a join request is accepted, all other join requests are rejected
  end
end