require_relative "./acceptance_helper"
require 'rake'

feature "Staff List Reminder" do
  # https://robots.thoughtbot.com/test-rake-tasks-like-a-boss
  # https://blog.pivotal.io/labs/labs/how-i-test-rake-tasks

  before do
    Rake.application.rake_require "tasks/staff_list_reminder"
    Rake::Task.define_task(:environment)
  end

  let :run_rake_task do
    Rake::Task["staff_responsibility_reminder"].reenable
    Rake.application.invoke_task "staff_responsibility_reminder"
  end

  context "two week reminder" do
    let!(:plan) { FactoryGirl.create(:op_within_two_weeks_approved) }

    it "sends two week reminder" do
      expect(StaffListReminder).to receive(:remind)
        .with(plan, 'staff_responsibility_reminder_2wk')
        .and_call_original

      expect(StaffResponsibilityReminderMailer).to receive(:send_responsibility_reminder)
        .with(plan)
        .and_call_original

      run_rake_task

      plan.reload
      expect(plan.staff_responsibility_reminder_2wk).to eq(true)
    end

    it "doesn't remind twice" do
      expect(StaffListReminder).to receive(:remind)
      run_rake_task

      expect(StaffListReminder).to_not receive(:remind)
      run_rake_task
    end
  end

  context "one week reminder" do
    let!(:plan) { FactoryGirl.create(:op_within_week_approved) }

    it "sends one week reminder" do
      expect(StaffListReminder).to receive(:remind)
        .with(plan, 'staff_responsibility_reminder_1wk')
        .and_call_original

      expect(StaffResponsibilityReminderMailer).to receive(:send_responsibility_reminder)
        .with(plan)
        .and_call_original

      run_rake_task

      plan.reload
      expect(plan.staff_responsibility_reminder_1wk).to eq(true)
      expect(plan.staff_responsibility_reminder_2wk).to eq(true)
    end

    it "doesn't remind twice" do
      expect(StaffListReminder).to receive(:remind)
      run_rake_task

      expect(StaffListReminder).to_not receive(:remind)
      run_rake_task
    end
  end

  context "past events" do
    let(:plan) { FactoryGirl.create(:past_op) }
    it "doesn't remind for past events" do
      expect(StaffListReminder).to_not receive(:remind)
      run_rake_task
    end
  end

  context "way far out events" do
    let(:plan) { FactoryGirl.create(:far_out_op) }
    it "doesn't remind far out" do
      expect(StaffListReminder).to_not receive(:remind)
      run_rake_task
    end
  end
end
