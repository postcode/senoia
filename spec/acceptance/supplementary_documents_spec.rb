require_relative "acceptance_helper"

feature "Supplementary Documents" do

  let(:plan) { create(:plan, creator: create(:user)) }
  let(:creator) { plan.creator }
  let(:admin) { create(:admin) }

  context "Creator", js: true do

    background do
      @document = create(:supplementary_document, parent: plan)
      sign_in(creator)
      visit "/plans/#{plan.id}"
    end

    let!(:document_name) { Faker::Lorem.words(3).join }

    scenario "adds a document" do
      click_on "ADD DOCUMENT"
      fill_in "supplementary_document_name", with: document_name
      fill_in "Description", with: Faker::Lorem.paragraph

      fake_direct_upload
      click_on "Save"
      visit "/plans/#{plan.id}"
      p document_name
      expect(page).to have_content document_name
    end

    scenario "removes a document" do
      within("#supplementary-document-#{@document.id}") { click_on "Remove" }
      expect(page).to_not have_content @document.name
    end

    scenario "can add a staff contact list" do
      click_on "ADD STAFF CONTACT LIST"
      fill_in "supplementary_document_name", with: document_name
      fill_in "Description", with: Faker::Lorem.paragraph

      fake_direct_upload
      click_on "Save"

      expect(page).to have_content document_name
    end

  end

  context "Administrator", js: true do
    background do
      @document = create(:supplementary_document, parent: plan)
      sign_in(admin)
      visit "/plans/#{plan.id}"
    end

    let(:document_name) { Faker::Lorem.words(3).join }

    scenario "mark a document for email" do
      within("#supplementary-document-#{@document.id}") { check "Email with plan approval" }
      save_screenshot
      click_on "SAVE DRAFT"

      expect(plan.supplementary_documents.first.email?).to eq true
    end
  end
end
