# == Schema Information
#
# Table name: permitters
#
#  id           :integer          not null, primary key
#  name         :string
#  phone_number :string
#  address      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Permitter, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
