require_relative "acceptance_helper"

feature "Plan Index" do

  let(:plan) { create(:plan_awaiting_review) }
  let(:accepted_plan) { create(:accepted_plan) }
  let(:admin) { create(:admin) }

  before do
    plan
    accepted_plan
  end

  context "Guest" do

    before do
      visit "/plans"
    end
    
    scenario "views accepted plans" do
      expect(page).to have_content accepted_plan.name
    end
    
    scenario "can't see unaccepted plans" do
      expect(page).to have_no_content plan.name
    end
  end

  context "Admin" do

    before do
      sign_in(admin)
      visit "/plans"
    end
    
    scenario "views accepted plans" do
      expect(page).to have_content accepted_plan.name
    end
    
    scenario "views unaccepted plans" do
      expect(page).to have_content plan.name
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
        expect(page).to_not have_content accepted_plan.name
      end

      scenario "views accepted plans", js: true do
        uncheck "My Plans"
        expect(page).to have_content accepted_plan.name
      end
    end

    context "without affiliated plans" do
      before do
        sign_in(user)
        visit "/plans"
      end
      scenario "views accepted plans" do
        expect(page).to have_content accepted_plan.name
      end
      
      scenario "can't see unaccepted plans" do
        expect(page).to have_no_content plan.name
      end

    end
  end
  
end
