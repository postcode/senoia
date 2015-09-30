require_relative "./acceptance_helper"

feature "Post Event Treatment Report" do

  let(:plan) { create(:accepted_plan, creator: create(:user)) }

  context "Plan Creator" do

    background do
      sign_in plan.creator
      visit "/plans/#{plan.id}"
    end

    scenario "files a report" do
      click_on "Post Event Treatment Report"
      fill_in "Actual crowd size", with: 10000
      click_on "Submit"
    end
    
  end
  
end
