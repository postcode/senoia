# == Schema Information
#
# Table name: notifications
#
#  id           :integer          not null, primary key
#  subject_id   :integer
#  subject_type :string
#  key          :text
#  owner_id     :integer
#  read         :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Notification, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
