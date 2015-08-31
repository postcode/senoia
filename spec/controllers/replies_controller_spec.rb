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
    end
  end  
end
