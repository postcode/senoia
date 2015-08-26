# == Schema Information
#
# Table name: operation_periods
#
#  id         :integer          not null, primary key
#  start_date :datetime
#  end_date   :datetime
#  attendance :integer
#  plan_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe OperationPeriod do

  let(:operation_period) { FactoryGirl.create(:operation_period) }
  
  context "#start_date=" do

    it "understands the m/d/Y H:M %p format" do
      operation_period.update(start_date: "06/24/1985 09:42 am")
      expect(operation_period.start_date).to eq DateTime.new(1985, 6, 24, 9, 42)
    end

    it "supports setting to nil" do
      operation_period.update(start_date: nil)
      expect(operation_period.start_date).to be_nil
    end
    
  end

  context "#end_date=" do

    it "understands the m/d/Y H:M %p format" do
      operation_period.update(end_date: "06/24/1985 09:42 am")
      expect(operation_period.end_date).to eq DateTime.new(1985, 6, 24, 9, 42)
    end

    it "supports setting to nil" do
      operation_period.update(end_date: nil)
      expect(operation_period.end_date).to be_nil
    end
    
  end

  
end
