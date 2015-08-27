require_relative "./acceptance_helper"

feature "Plan" do
  let(:plan) { FactoryGirl.create(:plan) }
  let(:accepted) { FactoryGirl.create(:plan) }
  let(:admin) { FactoryGirl.create(:admin) }

  context "not logged in" do
    scenario "show all of the accepted plans" do
      accepted.submit!
      accepted.review!
      accepted.accept!
      visit "/plans"
      expect(page).to have_content "#{accepted.name}"
    end
    scenario "don't show unaccepted plans" do
      visit "/plans"
      expect(page).to have_no_content "#{plan.name}"
    end
  end

  context "logged in as an admin" do
    scenario "show all of the accepted plans" do
      sign_in(admin)
      accepted.submit!
      accepted.review!
      accepted.accept!
      visit "/plans"
      expect(page).to have_content "#{accepted.name}"
    end
    scenario "show unaccepted plans" do
      sign_in(admin)
      plan.submit!
      visit "/plans"
      expect(page).to have_content "#{plan.name}"
    end
  end

  context "create a new plan" do

    before do
      sign_in(admin)
      count = Plan.all.count
      visit "/plans/new"
      fill_in 'plan_name', with: "test plan"
      fill_in 'plan_operation_periods_attributes_0_start_date', with: "01/01/2020 08:00 am"
      fill_in 'plan_operation_periods_attributes_0_end_date', with: "01/03/2020 08:00 pm"
    end
    
    scenario "admin can create a basic plan" do
      expect{ 
        click_button 'SUBMIT PLAN'
      }.to change { Plan.count }.by(1)
    end

    scenario "admin can create a plan with a first aid station", js: true  do
      click_link 'new_first_aid_station'

      first_aid_station_name = "2nd Aid Station"
      within '.first_aid_stations_id_name' do
        fill_in 'Name', with: first_aid_station_name
      end

      click_on "new-first-aid-station-submit"
      expect(page).to have_content first_aid_station_name

      expect { 
        click_button 'SUBMIT PLAN'
      }.to change{ FirstAidStation.count }.by(1)
    end
  end

  context "deleting medical assets" do

    let(:plan) { FactoryGirl.create(:plan) }
    let(:operation_period) { FactoryGirl.create(:operation_period) }
    let(:first_aid_station) { FactoryGirl.create(:first_aid_station) }
    let(:mobile_team) { FactoryGirl.create(:mobile_team) }
    let(:transport) { FactoryGirl.create(:transport) }
    let(:dispatch) { FactoryGirl.create(:dispatch) }

    before do
      plan.operation_periods << operation_period
      operation_period.first_aid_stations << first_aid_station
      operation_period.mobile_teams << mobile_team
      operation_period.transports << transport
      operation_period.dispatchs << dispatch
    end

    %w(first_aid_station mobile_team transport dispatch).each do |asset_type|
      
      scenario "admin can delete a #{asset_type.humanize.downcase}", js: true do

        sign_in(admin)
        visit "/plans/#{plan.id}"

        asset = send(asset_type)
        asset_selector = "input[value='#{asset.name}']"
        
        expect(page).to have_selector(asset_selector)

        asset_row = find(asset_selector).find(:xpath, "../../..")

        within(asset_row) {
          check "Remove"
        }
        
        click_on "SAVE DRAFT"

        expect(page).to_not have_selector(asset_selector)
      end
    end
  end

end
