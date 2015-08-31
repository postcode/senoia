# == Schema Information
#
# Table name: event_types
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class EventType < ActiveRecord::Base
  has_many :plans

  def to_s
    name
  end
end
