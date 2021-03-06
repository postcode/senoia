# == Schema Information
#
# Table name: operation_periods
#
#  id                         :integer          not null, primary key
#  start_date                 :datetime
#  end_date                   :datetime
#  attendance                 :integer
#  plan_id                    :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  patients_treated_count     :integer
#  patients_transported_count :integer
#  start_time                 :datetime
#  end_time                   :datetime
#  service_area               :text
#  crowd_estimate             :string
#  location                   :text
#

require 'rails_helper'

describe OperationPeriod do

  let(:operation_period) { FactoryGirl.create(:operation_period) }

  context "#start_date=" do

    it "understands the m/d/Y format" do
      operation_period.update(start_date: "06/24/1985")
      expect(operation_period.start_date).to eq DateTime.new(1985, 6, 24)
    end

    it "supports setting to nil" do
      operation_period.update(start_date: nil)
      expect(operation_period.start_date).to be_nil
    end

  end

  context "#end_date=" do

    it "understands the m/d/Y H:M %p format" do
      operation_period.update(end_date: "06/24/1985")
      expect(operation_period.end_date).to eq DateTime.new(1985, 6, 24)
    end

    it "supports setting to nil" do
      operation_period.update(end_date: nil)
      expect(operation_period.end_date).to be_nil
    end

  end


end
