# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  plan_id         :integer
#  email           :text
#  role            :string
#  invited_user_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Invitation, type: :model do

  describe "#claim_invitations" do
    pending
  end
  
end
