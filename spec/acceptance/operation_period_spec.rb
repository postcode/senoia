require_relative "./acceptance_helper"

feature "OperationPeriod" do

  let(:admin) { FactoryGirl.create(:admin) }
  let(:permitter_type) { FactoryGirl.create(:permitter_type) }
  let(:permitters) { 1.upto(3).map{ |i| FactoryGirl.create(:permitter, organization_type: permitter_type) }.sort_by(&:name) }
  let(:plan) { FactoryGirl.create(:no_operation_period, workflow_state: "draft", organization: permitters[1]) }


  context "admin create a new operation period" do
    before do
      sign_in(admin)
      visit "/plans/#{plan.id}"
    end

    scenario "admin can create a basic operation period", js: true do
      within "#panel0" do
        fill_in 'operation_period_start_date', with: '01/01/2020'
        fill_in 'operation_period_start_time', with: '8:00am'
        fill_in 'operation_period_end_date', with: '01/07/2020'
        fill_in 'operation_period_end_time', with: '8:00pm'
        fill_in 'operation_period_attendance', with: '10000'
      end

      expect{
        page.find('body').click
        find('.save-operation-period', text: 'Save').trigger('click')
        visit "/plans/#{plan.id}"
      }.to change { OperationPeriod.count }.by(1)
    end
  end
end
