require_relative "acceptance_helper"

feature "Plan Index" do

  let(:plan) { create(:plan_under_review) }
  let(:approved_plan) { create(:approved_plan) }
  let(:admin) { create(:admin) }

  before do
    plan
    approved_plan
  end

  context "Guest" do

    before do
      visit "/plans"
    end
    
    scenario "views approved plans" do
      expect(page).to have_content approved_plan.name
    end
    
    scenario "can't see unapproved plans" do
      expect(page).to have_no_content plan.name
    end
  end

  context "Admin" do

    let(:high_attendance_plan) { create(:plan, operation_periods: [ create(:operation_period, attendance: 45000) ]) }

    before do
      high_attendance_plan
      sign_in(admin)
      visit "/plans"
    end
    
    scenario "views approved plans" do
      expect(page).to have_content approved_plan.name
    end
    
    scenario "views unapproved plans" do
      expect(page).to have_content plan.name
    end

    scenario "filters by state", js: true do
      check "Approved"
      expect(page).to have_content approved_plan.name
      expect(page).to_not have_content plan.name
      check "Under Review"
      expect(page).to have_content plan.name
    end

    scenario "filters by attendance", js: true do
      check "15,500 - 50,000"
      expect(page).to have_content high_attendance_plan.name
      expect(page).to_not have_content plan.name
    end

    scenario "filters by event type", js: true do
      check plan.event_type.name
      expect(page).to have_content plan.name
      expect(page).to_not have_content approved_plan.name
    end

    scenario "sorts by attendance", js: true do
      click_on "Attendance"
      expect(page).to_not have_selector(".loading")
      expect(first("#plans tr td.name", visible: true)).to have_content high_attendance_plan.name
      expect(page).to_not have_selector(".loading")
      expect(all("#plans tr td.attendance").last).to have_content ""
    end

    scenario "filters by start date", js: true do
      find("#query_start_date").set(high_attendance_plan.end_date + 1.day)
      expect(page).to_not have_content high_attendance_plan.name
    end

    scenario "filters by end date", js: true do
      find("#query_end_date").set(high_attendance_plan.start_date - 1.day)
      expect(page).to_not have_content high_attendance_plan.name
    end
  end

  context "User" do

    let(:user) { create(:user) }
    let(:created_plan) { create(:plan) }
    let(:viewable_plan) { create(:plan) }

    context "with affiliated plans" do
      before do
        created_plan.update(creator: user)
        viewable_plan.users_who_can_view << user
        
        sign_in(user)
        visit "/plans"
      end

      scenario "views plans they created" do
        expect(page).to have_content created_plan.name
      end

      scenario "views plans they can see" do
        expect(page).to have_content viewable_plan.name
      end

      scenario "has 'My Plans' checked by default" do
        expect(page).to have_checked_field("My Plans")
      end

      scenario "sees only their plans by default" do
        expect(page).to_not have_content approved_plan.name
      end

      scenario "views approved plans", js: true do
        uncheck "My Plans"
        expect(page).to have_content approved_plan.name
      end
    end

    context "without affiliated plans" do
      before do
        sign_in(user)
        visit "/plans"
      end
      scenario "views approved plans" do
        expect(page).to have_content approved_plan.name
      end
      
      scenario "can't see unapproved plans" do
        expect(page).to have_no_content plan.name
      end

      scenario "can't see plan status" do
        expect(page).to_not have_content "Status"
      end

    end
  end
  
end
