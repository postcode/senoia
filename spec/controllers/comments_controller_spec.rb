require 'rails_helper'

RSpec.describe CommentsController do
  describe "#create" do

    let(:plan) { FactoryGirl.create(:plan) }
    let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }
    
    context "when logged in as admin" do

      login_admin

      it "creates a comment" do
        post :create, { "comment" => { "body" => Faker::Lorem.paragraph }, "element_id" => "contact_comment_text", "plan_id" => plan.id, "format" => "js" }
        expect(response).to be_success
        expect(assigns(:comment)).to be_an_instance_of Comment
      end

      let(:notification_recipient) { FactoryGirl.create(:user) }

      it "sends notifications" do

        plan.users_who_can_view << notification_recipient
        
        expect(NotificationMailer).to receive(:new_comment_notification)
          .with({ recipient: notification_recipient, comment: kind_of(Comment) })
          .and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_later)

        post :create, { "comment" => { "body" => Faker::Lorem.paragraph }, "element_id" => "contact_comment_text", "plan_id" => plan.id, "format" => "js" }
      end
      
    end
  end
end
