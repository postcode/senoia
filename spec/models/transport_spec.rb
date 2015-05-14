# == Schema Information
#
# Table name: transports
#
#  id          :integer          not null, primary key
#  name        :string
#  level       :string
#  provider_id :integer
#  lat         :decimal(10, 6)
#  lng         :decimal(10, 6)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Transport, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
