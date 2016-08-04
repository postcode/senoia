require_relative "./acceptance_helper"

feature "Medical Provider Confirmation" do

  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let(:plan) { create(:plan_under_review, operation_periods: [ create(:operation_period) ]) }
  let(:operation_period) { plan.operation_periods.first }
  let(:permitter_type) { FactoryGirl.create(:permitter_type) }
  let!(:permitters) { 1.upto(3).map{ |i| FactoryGirl.create(:permitter, organization_type: permitter_type) }.sort_by(&:name) }
  let(:provider_type) { FactoryGirl.create(:provider_type) }
  let!(:providers) { 1.upto(3).map{ |i| FactoryGirl.create(:provider, organization_type: provider_type, email: user.email, contact_users: [ user ]) }.sort_by(&:name) }

  context "Medical Provider Contact" do

    context "when a medical asset is added to a plan", js: true do

      before do
        plan
        operation_period

        sign_in(admin)
        visit "/plans/#{plan.id}"
        click_link 'new_first_aid_station'
        sleep 0.5 #FIXME Waiting for modal

        within '.first_aid_station_name' do
          fill_in 'Name', with: Faker::Lorem.word
        end

         within ".first_aid_station_organization_id" do
          select_from_chosen(providers.first.name, from: "first_aid_station_organization_id")
        end

        click_on "Confirm This Asset"
        sign_out
        @email = find_email(providers.first.email)
      end

      scenario "gets a confirmation email" do
        expect(@email).to_not be_nil
        expect(@email).to have_body_text("#{admin} of #{plan} has indicated that")
      end

      context "when clicking yes on the confirmation email" do

        before do
          open_email(providers.first.email)
          visit_in_email("Yes")
        end

        scenario "they are asked to log in" do
          expect(page).to have_content "Login"
        end

        context "after they log in" do

          before do
            fill_in_login_information(providers.first.contact_users.first)
          end

          scenario "the request is confirmed" do
            visit_in_email("Yes")
            expect(page).to have_content "Confirming..."
          end

        end

      end

      context "when clicking no on the confirmation email" do

        before do
          open_email(providers.first.email)
          visit_in_email("No")
        end

        scenario "they are asked to log in" do
          expect(page).to have_content "Login"
        end

        context "after they log in" do

          before do
            fill_in_login_information(providers.first.contact_users.first)
          end

          scenario "the request is rejected" do
            visit_in_email("No")
            expect(page).to have_content "Rejecting..."
          end

        end

      end
    end

    context "when a medical asset changes providers", js: true do

      before do
        operation_period.first_aid_stations << create(:first_aid_station)

        sign_in(admin)
        visit "/plans/#{plan.id}"
        click_link "new_first_aid_station"
        within "#new-first-aid-station-0" do\
          select_from_chosen(providers.first.name, from: "first_aid_station_organization_id")
          select "ALS", from: "first_aid_station_level"
          fill_in "first_aid_station_name", with: "test first aid station"
          fill_in "first_aid_station_md", with: "0"
          fill_in "first_aid_station_rn", with: "0"
          fill_in "first_aid_station_emt", with: "0"
          fill_in "first_aid_station_aed", with: "0"
          fill_in "first_aid_station_location", with: "test"
          find(".save-first-aid-station", text: "Confirm This Asset").trigger("click")
        end
        wait_for_ajax
        within "#floating-actions" do
          find("button", text: "SAVE").trigger("click")
        end
        expect(page).to have_no_content("Don't forget to save your progress!")
        sign_out
        save_screenshot
        wait_for_ajax
        @email = find_email!(providers.first.email)
      end

      scenario "gets a confirmation email" do
        expect(@email).to_not be_nil
        expect(@email).to have_body_text("confirm your participation")
      end
    end
  end

end
