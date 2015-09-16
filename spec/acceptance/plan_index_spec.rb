require_relative "acceptance_helper"

feature "Plan Index" do

  let(:plan) { create(:plan_awaiting_review) }
  let(:accepted_plan) { create(:accepted_plan) }
  let(:admin) { create(:admin) }

  before do
    plan
    accepted_plan
  end

  context "not logged in" do

    before do
      visit "/plans"
    end
    
    scenario "show all of the accepted plans" do
      expect(page).to have_content accepted_plan.name
    end
    
    scenario "don't show unaccepted plans" do
      expect(page).to have_no_content plan.name
    end
  end

  context "logged in as an admin" do

    before do
      sign_in(admin)
      visit "/plans"
    end
    
    scenario "show all of the accepted plans" do
      expect(page).to have_content accepted_plan.name
    end
    
    scenario "show unaccepted plans" do
      expect(page).to have_content plan.name
    end
  end

end
