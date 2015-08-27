require_relative "./acceptance_helper"

feature "Plan" do
  let(:plan) { FactoryGirl.create(:plan) }
  let(:accepted) { FactoryGirl.create(:plan) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:permitters) { 1.upto(3).map{ |i| FactoryGirl.create(:permitter) }.sort_by(&:name) }

  context "not logged in" do
    scenario "show all of the accepted plans" do
      accepted.submit!
      accepted.review!
      accepted.accept!
      visit "/plans"
      expect(page).to have_content "#{accepted.name}"
    end
    scenario "don't show unaccepted plans" do
      visit "/plans"
      expect(page).to have_no_content "#{plan.name}"
    end
  end

  context "logged in as an admin" do
    scenario "show all of the accepted plans" do
      sign_in(admin)
      accepted.submit!
      accepted.review!
      accepted.accept!
      visit "/plans"
      expect(page).to have_content "#{accepted.name}"
    end
    scenario "show unaccepted plans" do
      sign_in(admin)
      plan.submit!
      visit "/plans"
      expect(page).to have_content "#{plan.name}"
    end
  end

  context "create a new plan" do

    scenario "admin can create a basic plan" do
      sign_in(admin)
      count = Plan.all.count
      visit "/plans/new"
      fill_in 'plan_name', with: "test plan"
      fill_in 'plan_operation_periods_attributes_0_start_date', with: "01/01/2020 08:00 am"
      fill_in 'plan_operation_periods_attributes_0_end_date', with: "01/03/2020 08:00 pm"
      click_button 'SUBMIT PLAN'
      expect(Plan.all.count).to eq count +1 
    end

    scenario "admin can create a plan with medical assets", js: true  do
      pending
      sign_in(admin)
      count = Plan.all.count
      visit "/plans/new"
      fill_in 'plan_name', with: "test plan"
      fill_in 'plan_operation_periods_attributes_0_start_date', with: "01/01/2020 08:00 am"
      fill_in 'plan_operation_periods_attributes_0_end_date', with: "01/03/2020 08:00 pm"
      click_link 'new_first_aid_station'
      within '.plan_operation_periods_id_first_aid_stations_id_name' do
        fill_in 'input', with: "test"
      end
      click_button 'SUBMIT PLAN'
      expect(Plan.all.count).to eq count +1 
    end

    scenario "changing permitting agencies shows their contact info", js: true do

      expect(permitters.count).to be > 1
      
      sign_in(admin)
      visit "/plans/new"
            
      expect(page).to have_content permitters.first.phone_number
      
      select(permitters.last.name, from: "plan_permitter_id")
      
      expect(page).to have_content permitters.last.phone_number
      
    end
    
  end

  context "viewing an existing plan" do

    let(:plan) { FactoryGirl.create(:plan, workflow_state: "awaiting_review") }

    before do
      plan.update(permitter: permitters[1])
    end

    scenario "changing permitting agencies shows their contact info", js: true do
      
      sign_in(admin)
      visit "/plans/#{plan.id}"
            
      expect(page).to have_content permitters[1].address
      
      select(permitters.first.name, from: "plan_permitter_id")
      
      expect(page).to have_content permitters.first.address
      
    end
    
  end
end
