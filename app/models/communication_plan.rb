# == Schema Information
#
# Table name: communication_plans
#
#  id                                    :integer          not null, primary key
#  event_coordinator_name                :string
#  event_coordinator_phone               :string
#  event_coordinator_email               :string
#  event_coordinator_organization        :string
#  event_supervisor_name                 :string
#  event_supervisor_phone                :string
#  event_supervisor_email                :string
#  dispatch_supervisor_name              :string
#  dispatch_supervisor_phone             :string
#  dispatch_supervisor_email             :string
#  dispatch_supervisor_organization      :string
#  medical_group_supervisor_name         :string
#  medical_group_supervisor_phone        :string
#  medical_group_supervisor_email        :string
#  medical_group_supervisor_organization :string
#  triage_supervisor_name                :string
#  triage_supervisor_phone               :string
#  triage_supervisor_email               :string
#  triage_supervisor_organization        :string
#  transport_supervisor_name             :string
#  transport_supervisor_email            :string
#  transport_supervisor_phone            :string
#  transport_supervisor_organization     :string
#  non_transport_supervisor_name         :string
#  non_transport_supervisor_email        :string
#  non_transport_supervisor_phone        :string
#  non_transport_supervisor_organization :string
#  plan_id                               :integer
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#

class CommunicationPlan < ActiveRecord::Base
  belongs_to :plan
  has_many :supplementary_documents, as: :parent
  
end
