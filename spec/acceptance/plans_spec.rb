require_relative "./acceptance_helper"

feature "Plan" do
  let!(:plan) { FactoryGirl.create(:plan) }

  context "there is content on the plans page when there are plans in the db" do
    scenario "show all of the plans" do
      visit "/plans"
      expect(page).to have_content "#{plan.name}"
    end
  end
end