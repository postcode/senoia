# == Schema Information
#
# Table name: organizations
#
#  id                   :integer          not null, primary key
#  name                 :string
#  address              :string
#  email                :string
#  phone_number         :string
#  organization_type_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Organization < ActiveRecord::Base
  has_many :organization_users
  has_many :users, through: :organization_users
  has_many :contact_users, -> { where("organization_users.contact" => true) }, source: :user, through: :organization_users

  belongs_to :organization_type

  validates :name, presence: true

  def save_organization_users(ids)
    ids.each do |user_id|
      if user_id[1] == "1"
        @organization_user = OrganizationUser.where(:organization_id => id, :user_id => user_id[0]).first_or_create
        @user = User.find(user_id[0])
        @organization_user.save!
      else
        if OrganizationUser.exists?(:organization_id => id, :user_id => user_id[0])
          OrganizationUser.where(:organization_id => id, :user_id => user_id[0]).delete_all
        end
      end
    end
  end
end
