require 'spec_helper'
require 'rake'


feature "Staff List Reminder" do

  # https://robots.thoughtbot.com/test-rake-tasks-like-a-boss
  # https://blog.pivotal.io/labs/labs/how-i-test-rake-tasks

  before do
    Rake.application.rake_require "tasks/staff_list_reminder"
    Rake::Task.define_task(:environment)

    print "Clearing" # TODO
    Plan.delete_all
    OperationPeriod.delete_all
  end

  let :run_rake_task do
    Rake::Task["staff_list_reminder"].reenable
    Rake.application.invoke_task "staff_list_reminder"
  end

  context "two week reminder" do
    scenario "sends two week reminder" do
      let(:plan) { FactoryGirl.create(:op_within_two_weeks) }

      expect(subject).to receive(:bar).with([plan])

    end

    scenario "Don't remind twice"
      let(:plan) { FactoryGirl.create(:op_within_two_weeks) }
    end

    scenario "Don't remind far out"
      let(:plan) { FactoryGirl.create(:far_out_op) }
    end

    scenario "Don't remind for past events"
      let(:plan) { FactoryGirl.create(:past_op) }
    end
  end
end
