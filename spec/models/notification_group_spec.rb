# == Schema Information
#
# Table name: notification_groups
#
#  id                :integer          not null, primary key
#  name              :string
#  description       :text
#  notification_type :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe NotificationGroup, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
