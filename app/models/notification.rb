class Notification < ActiveRecord::Base
  belongs_to :owner, class_name: "User", inverse_of: :notifications
  belongs_to :subject, polymorphic: true
  validates :subject, presence: true
  validates :key, presence: true

  after_create do
    NotificationMailer.notification(notification: self).deliver_later
  end

  scope :unread, -> { where(read: false) }

  def partial
    [ subject_type.underscore, key ].join("/")
  end

  def translation_key
    [ subject_type.underscore, key ].join(".")
  end

end
