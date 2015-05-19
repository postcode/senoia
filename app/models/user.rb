# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string
#  last_name              :string
#  role                   :string           default("guest"), not null
#  organization_id        :integer
#  phone_number           :string
#

class User < ActiveRecord::Base
  require 'role_model'
  include RoleModel
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :registerable,
         :recoverable, 
         :rememberable, 
         :trackable, 
         :validatable, 
         :confirmable

  has_many :plans

  roles_attribute :roles_mask

  # declare the valid roles -- do not change the order if you add more
  # roles later, always append them at the end!
  roles :admin, :user, :guest
end
