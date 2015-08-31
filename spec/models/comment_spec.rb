# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_id   :integer
#  commentable_type :string
#  title            :string
#  body             :text
#  subject          :string
#  user_id          :integer          not null
#  parent_id        :integer
#  lft              :integer
#  rgt              :integer
#  created_at       :datetime
#  updated_at       :datetime
#  element_id       :string
#  open             :boolean          default(TRUE)
#

require 'rails_helper'

describe Comment do
  let(:user) { FactoryGirl.create(:user) }
  let(:plan) { FactoryGirl.create(:plan) }
  let(:operation_period) { FactoryGirl.create(:operation_period) }
  let(:comment) { FactoryGirl.create(:comment) }
  
  describe '#create' do 
    it 'creates a new comment for a plan' do
      expect {
        Comment.create(commentable: plan, user: user, body: "test comment", element_id: "test_id")
      }.to change { plan.root_comments.count }.by(1)
    end

    it 'creates a new comment for an operation period' do
      expect {
        Comment.create(commentable: operation_period, user: user, body: "test comment", element_id: "test_id")
      }.to change { operation_period.root_comments.count }.by(1)
    end
  end

  describe "#create_reply" do

    it "creates a reply" do
      expect {
        comment.create_reply(body: Faker::Lorem.paragraph, user: comment.user)
      }.to change{ comment.children.count }.by(1)
    end
    
  end
  
end
