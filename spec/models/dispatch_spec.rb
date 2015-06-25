# == Schema Information
#
# Table name: dispatches
#
#  id                  :integer          not null, primary key
#  name                :string
#  level               :string
#  provider_id         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  operation_period_id :integer
#

require 'rails_helper'

RSpec.describe Dispatch, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
