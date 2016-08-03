require_relative "./acceptance_helper"

feature "OperationPeriod" do

  let(:admin) { FactoryGirl.create(:admin) }
  let(:promoter) { FactoryGirl.create(:promoter_user) }
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

  context "promoter create a new operation period" do
    before do
      plan.plan_users << FactoryGirl.create(:plan_user, user: promoter, plan: plan, role: "edit")
      plan.save
      sign_in(promoter)
      visit "/plans/#{plan.id}"
    end

    scenario "promoter can create a basic operation period", js: true do
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

  context "asset text is updated when an operation period is created", js: true do
    before do
      sign_in(admin)
      plan.event_type = create(:concert)
      plan.save
     end

    scenario "admin can create a basic operation period" do
      create_operation_period(1000)
      expect(page).to have_content "You will need at least 1 First Aid Station."
      expect(page).to have_content "It is recommended that you have 1 or more Mobile Teams."
    end
  end

  def create_operation_period(attendance)
    visit "/plans/#{plan.id}"
    within "#panel0" do
      fill_in 'operation_period_start_date', with: '01/01/2020'
      fill_in 'operation_period_start_time', with: '8:00am'
      fill_in 'operation_period_end_date', with: '01/07/2020'
      fill_in 'operation_period_end_time', with: '8:00pm'
      fill_in 'operation_period_attendance', with: attendance
    end

    page.find('body').click
    find('.save-operation-period', text: 'Save').trigger('click')
  end
end
