# == Schema Information
#
# Table name: post_event_treatment_reports
#
#  id                                       :integer          not null, primary key
#  plan_id                                  :integer
#  creator_id                               :integer
#  actual_crowd_size                        :integer
#  resource_differences                     :text
#  medical_resource_sufficiency             :string
#  medical_resource_sufficiency_explanation :text
#  other_comments                           :text
#  submitted                                :boolean
#  created_at                               :datetime         not null
#  updated_at                               :datetime         not null
#  weather                                  :text
#

class PostEventTreatmentReport < ActiveRecord::Base
  belongs_to :plan
  belongs_to :creator, class_name: "User"

  has_many :supplementary_documents, as: :parent
  has_many :transportation_records, inverse_of: :post_event_treatment_report
  has_many :treatment_records, inverse_of: :post_event_treatment_report

  VALID_MEDICAL_RESOURCE_SUFFICIENCY_OPTIONS = [ "too_few", "too_many", "appropriate" ]
  validates :medical_resource_sufficiency, inclusion: VALID_MEDICAL_RESOURCE_SUFFICIENCY_OPTIONS, allow_blank: true

  validates :plan, presence: true

  %w(actual_crowd_size resource_differences medical_resource_sufficiency medical_resource_sufficiency_explanation).each do |attribute|
    validates attribute, presence: true, if: :submitted?
  end

  scope :with_plan, -> { where("plan_id is not null") }

  delegate :event_type, :start_date, :end_date, :attendance, to: :plan

  def submit_email!
    plan.users.each do |contact|
      PostEventTreatmentReportMailer.submit(recipient: contact, plan: plan).deliver_later
    end
    PostEventTreatmentReportMailer.submit(recipient: User.find_by_email("aram.bronston@sfgov.org"), plan: plan).deliver_later
  end

  def treatment_total
    treatment_records.map.sum(&:persons_count)
  end

  def treatments
    treatment_records.map(&:treatment)
  end
end
