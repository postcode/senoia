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
#

require 'rails_helper'

describe Comment do
  let(:user) { FactoryGirl.create(:user) }
  let(:plan) { FactoryGirl.create(:plan) }
  
  context 'create a comment' do
    describe '#build_from' do 
      it 'creates a new comment for a plan' do
        count = plan.root_comments.count
        comment = Comment.build_from(plan, user.id, "test comment", "test_id")
        comment.save
        expect(plan.root_comments.count).to eq count+1
      end
    end
  end
end
