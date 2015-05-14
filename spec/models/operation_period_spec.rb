# == Schema Information
#
# Table name: operation_periods
#
#  id         :integer          not null, primary key
#  start_date :datetime
#  end_date   :datetime
#  attendance :integer
#  plan_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe OperationPeriod, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
