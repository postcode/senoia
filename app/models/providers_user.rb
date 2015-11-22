# == Schema Information
#
# Table name: providers_users
#
#  id          :integer          not null, primary key
#  provider_id :integer
#  user_id     :integer
#  contact     :boolean
#

class ProvidersUser < ActiveRecord::Base
  belongs_to :provider
  belongs_to :user
end
