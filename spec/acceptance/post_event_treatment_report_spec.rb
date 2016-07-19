require_relative "./acceptance_helper"

feature "Post Event Treatment Report" do

  shared_examples "editable post event treatment report" do
    scenario "saves an incomplete report" do
      fill_in "Actual crowd size", with: 10000
      click_on "Save Draft"
      expect(page).to have_no_selector "span.error"
    end

    scenario "files a report" do
      fill_in "Actual crowd size", with: 10000
      fill_in "post_event_treatment_report_resource_differences", with: Faker::Lorem.paragraph
      choose "Appropriate"
      fill_in "Please Explain", with: Faker::Lorem.paragraph
      fill_in "post_event_treatment_report_other_comments", with: Faker::Lorem.paragraph
      click_on "Submit"
      expect(page).to have_content "10000"
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

    scenario "adds a transportation record", js: true do
      add_transportation_record
    end

    scenario "removes a transportation record", js: true do
      add_transportation_record
      within "#transportation-records" do
        click_on "Remove"
      end
      expect(page).to_not have_selector(".transportation-record")
    end

    scenario "reports operation period patient treatment count", js: true do
      fill_in "operation_period_patients_treated_count", with: 100
      page.execute_script %Q{ $("#operation_period_patients_treated_count").trigger("blur") }
      visit "/plans/#{plan.id}/post_event_treatment_report"
      expect(page).to have_selector "#operation_period_patients_treated_count[value='100']"
    end

    scenario "reports operation period patient transportation count", js: true do
      fill_in "operation_period_patients_transported_count", with: 100
      page.execute_script %Q{ $("#operation_period_patients_transported_count").trigger("blur") }
      visit "/plans/#{plan.id}/post_event_treatment_report"
      expect(page).to have_selector "#operation_period_patients_transported_count[value='100']"
    end

    scenario "adds a document", js: true do
      click_on "ADD DOCUMENT"
      fill_in "supplementary_document_name", with: (document_name = Faker::Lorem.words(3).join)
      fill_in "Description", with: Faker::Lorem.paragraph

      fake_direct_upload
      click_on "Save"

      expect(page).to have_content document_name
    end
  end

  let(:plan) do
    create(:approved_plan,
           creator: create(:user),
           operation_periods: [ operation_period ])
  end

  let(:operation_period) do
    create(:operation_period,
           transports: [ transport ])
  end

  let(:transport) { create(:transport) }

  context "Plan Creator" do

    background do
      sign_in plan.creator
      visit "/plans/#{plan.id}"
      click_on "Post Event Treatment Report"
    end

    include_examples "editable post event treatment report"

  end

  context "Plan Editor" do

    let(:editor) { create(:user) }

    background do
      plan.users_who_can_edit << editor
      sign_in editor
      visit "/plans/#{plan.id}"
      click_link "Post Event Treatment Report"
    end

    include_examples "editable post event treatment report"

  end

  def add_transportation_record
    within "#transportation-records" do
      click_on "+"
      fill_in "transportation_record_chief_complaint", with: Faker::Lorem.words(7).join(" ")
      select transport.name, from: "transportation_record_transport_id"
      fill_in "transportation_record_destination", with: Faker::Lorem.words(3).join(" ")
      find("#transportation_record_transported_at").trigger("focus")
      page.execute_script %Q{ $("td.day:contains('15')").trigger("click") }
      page.execute_script %Q{ $("span.hour:contains('12:00')").trigger("click") }
      page.execute_script %Q{ $("span.minute:contains('12:30')").trigger("click") }
      click_on "Save"
      expect(page).to have_selector(".transportation-record")
      expect(page).to have_content transport.name
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
