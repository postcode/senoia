require_relative "acceptance_helper"

feature "Supplementary Documents" do

  let(:plan) { create(:plan, creator: create(:user)) }
  let(:creator) { plan.creator }

  context "Creator", js: true do
    
    background do
      @document = create(:supplementary_document, parent: plan)
      sign_in(creator)
      visit "/plans/#{plan.id}"
    end

    let(:document_name) { Faker::Lorem.words(3).join }
    
    scenario "adds a document" do
      click_on "ADD DOCUMENT"
      fill_in "supplementary_document_name", with: document_name
      fill_in "Description", with: Faker::Lorem.paragraph

      fake_direct_upload
      click_on "Save"

      expect(page).to have_content document_name
    end

    scenario "removes a document" do
      within("#supplementary-document-#{@document.id}") { click_on "Remove" }
      expect(page).to_not have_content @document.name
    end

  end
end
