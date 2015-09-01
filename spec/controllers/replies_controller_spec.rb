require 'rails_helper'

RSpec.describe RepliesController do

  let(:comment) { create(:comment) }
  
  context "when logged in as admin" do

    login_admin

    describe "#create" do

      it "creates a reply" do
        expect {
          post :create, comment_id: comment.id, comment: { body: Faker::Lorem.paragraph }, format: "js"
        }.to change{ comment.children.count }.by(1)
      end

      it "assigns a reply" do
        post :create, comment_id: comment.id, comment: { body: Faker::Lorem.paragraph }, format: "js"
        expect(comment.children).to include(assigns(:reply))
      end

      let(:notification_recipient) { FactoryGirl.create(:user) }
      let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }
      
      it "sends notifications" do

        comment.commentable.users_who_can_view << notification_recipient
        
        expect(NotificationMailer).to receive(:new_comment_notification)
          .with({ recipient: notification_recipient, comment: kind_of(Comment) })
          .and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_later)

        post :create, { "comment" => { "body" => Faker::Lorem.paragraph }, "element_id" => "contact_comment_text", "comment_id" => comment.id, "format" => "js" }
      end
    end
  end  
end
