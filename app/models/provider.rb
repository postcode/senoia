# == Schema Information
#
# Table name: providers
#
#  id           :integer          not null, primary key
#  name         :string
#  phone_number :string
#  address      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Provider < ActiveRecord::Base
  has_many :providers_users
  has_many :users, through: :providers_users
  has_many :contact_users, -> { where("providers_users.contact" => true) }, source: :user, through: :providers_users
  
  has_many :first_aid_stations
  has_many :dispatchs
  has_many :transports
  has_many :mobile_teams
  has_many :provider_confirmations

  def to_s
    name
  end

  def save_provider_users(ids)
    ids.each do |user_id|
      if user_id[1] == "1"
        @provider_user = ProvidersUser.where(:provider_id => id, :user_id => user_id[0]).first_or_create
        @user = User.find(user_id[0])
        @provider_user.save!
      else
        if ProvidersUser.exists?(:provider_id => id, :user_id => user_id[0])
          ProvidersUser.where(:provider_id => id, :user_id => user_id[0]).delete_all
        end
      end
    end
  end
end
