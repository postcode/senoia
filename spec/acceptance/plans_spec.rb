require_relative "./acceptance_helper"

feature "Plan" do
  
  let(:plan) { FactoryGirl.create(:plan) }
  let(:accepted) { FactoryGirl.create(:plan) }
  let(:admin) { FactoryGirl.create(:admin) }

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
      fill_in 'operation_periods_id_1_start_date', with: "01/01/2020 08:00 am"
      fill_in  'operation_periods_id_1_end_date', with: "01/03/2020 08:00 pm"
      click_button 'SUBMIT PLAN'
      
      expect(Plan.all.count).to eq count +1 
      expect(find_email(admin.email, with_text: "plan has been submitted")).to_not be_nil
    end

    scenario "admin can create a plan with medical assets", js: true  do
      pending
      sign_in(admin)
      count = Plan.all.count
      visit "/plans/new"
      fill_in 'plan_name', with: "test plan"
      fill_in 'operation_periods_id_1_start_date', with: "01/01/2020 08:00 am"
      fill_in  'operation_periods_id_1_end_date', with: "01/03/2020 08:00 pm"
      click_link 'new_first_aid_station'
      within '.operation_periods_id_first_aid_stations_id_name' do
        fill_in 'input', with: "test"
      end
      click_button 'SUBMIT PLAN'
      expect(Plan.all.count).to eq count +1 
    end
  end

  context "request revision" do

    let(:plan) { FactoryGirl.create(:plan, workflow_state: "awaiting_review") }
    let(:creator) { FactoryGirl.create(:user) }
    
    before do
      plan.update(creator: creator)
    end
    
    scenario "admin can request a revision" do
      
      sign_in(admin)
      visit "/plans/#{plan.id}"

      click_link "REQUEST REVISION"
      expect(find_email(creator.email, with_text: "needs revision")).to_not be_nil
    end
    
  end

  context "approve plan" do
    
    let(:plan) { FactoryGirl.create(:plan, workflow_state: "being_reviewed") }
    let(:creator) { FactoryGirl.create(:user) }
    
    before do
      plan.update(creator: creator)
    end
    
    scenario "admin can approve a plan", js: true do

      count = Plan.where(workflow_state: "accepted").count
      sign_in(admin)
      visit "/plans/#{plan.id}"

      expect { 
        click_link "APPROVE PLAN"
      }.to change{ Plan.with_accepted_state.count }.by(1)

      email = find_email(creator.email)
      expect(email).to_not be_nil
      expect(email).to have_body_text("has been approved")
    end

  end
  
end
