require 'spec_helper'

describe PrivateMessageController do
  describe "GET new" do
    it "renders the new template for creating a private message"
    it "sets @private_message"
    context "when sending a join request" do
      it "sets the @project.id"
      it "sets @user.organization_administrator"
    end
  end

  describe "POST create" do
    context "when requesting to join a project" do
      it "changes the project’s state from open to pending on the freelancers dashboard"
      it "changes the project’s state from open to pending on the organization admin's dashboard"
      it "changes the project’s state from open to pending on the organization's board"
      it "changes the project’s state from open to pending only on the organization's board, organization admin's dashboard and the freelancers dashboard"
      it ""
      it "remains open on the project index"

      it "flash's a success notice that your join request has been sent"
      it "organization admin receives a private message from the freelancer"
      it "triggers a private message alert on the recipient's notification icon"
      it "notifies the organization admin that a user wants to join his/her project"
    end
  end

  describe "GET show" do
    it "renders the show template for a private message"
    it "shows a received private message"
    it "shows the conversation between the sender and the recipient"
    it "shows the reply button"
    it "redirects the user to a new conversation if the user clicks reply"
    context "when its a join request"
      it "shows a an option to accept the join request"
      it "shows an option to reject the join request"
      it "shows an option to reply to the private message"
      ##when a join request is accepted, all other join requests are rejected
  end

end