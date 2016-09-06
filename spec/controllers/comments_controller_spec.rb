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
    end

    context "when logged in as a user" do

      login_user

      it "creates a comment" do
        post :create, { "comment" => { "body" => Faker::Lorem.paragraph }, "element_id" => "contact_comment_text", "plan_id" => plan.id, "format" => "js" }
        expect(response).to be_success
        expect(assigns(:comment)).to be_an_instance_of Comment
      end
    end
  end
end
