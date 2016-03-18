# == Schema Information
#
# Table name: plan_venues
#
#  id       :integer          not null, primary key
#  plan_id  :integer
#  venue_id :integer
#

class PlanVenue < ActiveRecord::Base
  belongs_to :venue
  belongs_to :plan
end
