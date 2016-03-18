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
#  contact_name        :string
#  contact_phone       :string
#  location            :text
#  lat                 :decimal(10, 6)
#  lng                 :decimal(10, 6)
#  service_area        :text
#

require 'rails_helper'

RSpec.describe Dispatch, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
