require_relative "./acceptance_helper"

feature "Post Event Treatment Report" do

  let(:plan) { create(:accepted_plan, creator: create(:user)) }

  context "Plan Creator" do

    background do
      sign_in plan.creator
      visit "/plans/#{plan.id}"
      click_on "Post Event Treatment Report"
    end

    scenario "files a report" do
      fill_in "Actual crowd size", with: 10000
      click_on "Submit"
    end

    scenario "adds a treatment record", js: true do
      add_treatment_record
    end

    scenario "removes a treatment record", js: true do
      add_treatment_record
      within "#treatment-records" do
        click_on "Remove"
      end
      expect(page).to_not have_selector(".treatment-record")
    end
    
  end

  def add_treatment_record
    within "#treatment-records" do
      click_on "+"
      all("input").each do |element|
        if element[:name] == "treatment_record[persons_count]"
          element.set(Random.rand(10000).to_s)
        else
          element.set(Faker::Lorem.paragraph)
        end
      end
      click_on "Save"
      expect(page).to have_selector(".treatment-record")
    end
  end

end
