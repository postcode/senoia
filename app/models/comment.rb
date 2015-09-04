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

class Comment < ActiveRecord::Base
  acts_as_nested_set :scope => [:commentable_id, :commentable_type]

  validates :body, :presence => true
  validates :user, :presence => true

  belongs_to :commentable, :polymorphic => true, :touch => true
  belongs_to :user

  scope :element, ->(element_id) { where("element_id = ?", element_id).order(created_at: :desc) }
  scope :open, -> { where("open = ?", true).order(created_at: :desc) }
  scope :plan, ->(plan_id) { where("commentable_id = ?", plan_id).order(created_at: :desc) }

  def create_reply(attributes)
    transaction do
      reply = self.class.create(attributes.merge(commentable: self.commentable, element_id: self.element_id))
      if reply.valid?
        reply.move_to_child_of(self)
      end
      self.touch
      reply
    end
  end

  def send_notifications!
    commentable.send_notifications_on_new_comment(self)
  end
  
end
