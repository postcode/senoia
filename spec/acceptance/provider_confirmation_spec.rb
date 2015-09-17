require_relative "./acceptance_helper"

feature "Medical Provider Confirmation" do

  let(:admin) { create(:admin) }
  let(:plan) { create(:plan_awaiting_review, operation_periods: [ create(:operation_period) ]) }
  let(:operation_period) { plan.operation_periods.first }
  let(:contact) { create(:medical_contact) }
  let(:provider) { contact.providers.first }
  
  context "Mecidal Provider Contact" do

    context "when a medical asset is added to a plan", js: true do

      before do
        plan
        operation_period
        provider
        
        sign_in(admin)
        visit "/plans/#{plan.id}"
        click_link 'new_first_aid_station'
        sleep 0.5 #FIXME Waiting for modal
        
        within '.first_aid_station_name' do
          fill_in 'Name', with: Faker::Lorem.word
        end
        select provider.name, from: "Provider"
        click_on "Add First Aid Station"
        sign_out
        @email = find_email(contact.email)
      end
      
      scenario "gets a confirmation email" do
        expect(@email).to_not be_nil
        expect(@email).to have_body_text("#{admin} of #{plan} has indicated that")
      end

      context "when clicking yes on the confirmation email" do

        before do
          open_email(contact.email)
          visit_in_email("Yes")
        end

        scenario "they are asked to log in" do
          expect(page).to have_content "Login"
        end

        context "after they log in" do

          before do
            fill_in_login_information(contact)
          end

          scenario "the request is confirmed" do
            expect(page).to have_content "Confirming..."
            visit_in_email("Yes")
            expect(page).to have_content "Confirmed"
          end
          
        end

      end
      
      context "when clicking no on the confirmation email" do

        before do
          open_email(contact.email)
          visit_in_email("No")
        end

        scenario "they are asked to log in" do
          expect(page).to have_content "Login"
        end

        context "after they log in" do

          before do
            fill_in_login_information(contact)
          end

          scenario "the request is rejected" do
            expect(page).to have_content "Rejecting..."
            visit_in_email("No")
            expect(page).to have_content "Rejected"
          end
          
        end

      end
    end

    context "when a medical asset changes providers", js: true do

      before do
        operation_period.first_aid_stations << create(:first_aid_station)
        provider
        
        sign_in(admin)
        visit "/plans/#{plan.id}"

        within ".plan_operation_periods_first_aid_stations_provider_id" do
          select provider.name
        end
        click_on "SAVE DRAFT"
        sign_out
        @email = find_email(contact.email)
      end
      
      scenario "gets a confirmation email" do
        expect(@email).to_not be_nil
        expect(@email).to have_body_text("confirm your participation")
      end
    end
  end
  
end
