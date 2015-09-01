require_relative "./acceptance_helper"

feature "Plan" do
  
  let(:plan) { FactoryGirl.create(:plan) }
  let(:accepted) { FactoryGirl.create(:plan) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:permitters) { 1.upto(3).map{ |i| FactoryGirl.create(:permitter) }.sort_by(&:name) }

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
      @event_type = create(:event_type)
      sign_in(admin)
      visit "/plans/new"
      fill_in 'plan_name', with: Faker::Lorem.words.join(" ")
      select @event_type.name, from: "plan_event_type_id"
    end
    
    scenario "admin can create a basic plan" do
      expect{ 
        click_button "Continue"
      }.to change { Plan.count }.by(1)
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

  context "viewing an existing plan" do

    let(:plan) { FactoryGirl.create(:plan, workflow_state: "awaiting_review", permitter: permitters[1]) }

    before do
      plan.operation_periods << create(:operation_period)

      sign_in(admin)
      visit "/plans/#{plan.id}"
    end
    
    scenario "changing permitting agencies shows their contact info", js: true do
      
      expect(page).to have_content plan.permitter.address
      
      select(permitters.first.name, from: "plan_permitter_id")
      
      expect(page).to have_content permitters.first.address
      
    end
    
    scenario "admin can add a dispatch", js: true  do
      click_on "ADD DISPATCH"
      
      dispatch_name = "Dispatch One"
      within '.dispatch_id_name' do
        find("input").set(dispatch_name)
      end

      expect { 
        click_button "SAVE DRAFT"
      }.to change{ Dispatch.count }.by(1)
    end

    scenario "admin can add a first aid station", js: true  do
      pending
      click_link 'new_first_aid_station'
      sleep 0.5 #FIXME Waiting for modal
      
      first_aid_station_name = "2nd Aid Station"
      within '.first_aid_stations_id_name' do
        fill_in 'Name', with: first_aid_station_name
      end

      click_on "new-first-aid-station-submit"

      expect(page).to have_content first_aid_station_name

      expect { 
        click_button 'SAVE DRAFT'
      }.to change{ FirstAidStation.count }.by(1)
    end

    scenario "admin can add a mobile team", js: true  do
      click_on "ADD MOBILE TEAM"
      
      mobile_team_name = "Mobility One"
      within '.mobile_teams_id_name' do
        find("input").set(mobile_team_name)
      end

      expect { 
        click_button 'SAVE DRAFT'
      }.to change{ MobileTeam.count }.by(1)
    end

    scenario "admin can add a transport", js: true  do
      click_on "ADD TRANSPORT"
      
      transport_name = "Transport One"
      within '.transport_id_name' do
        find("input").set(transport_name)
      end

      expect { 
        click_button 'SAVE DRAFT'
      }.to change{ Transport.count }.by(1)
    end

  end

  context "request revision" do

    let(:plan) { FactoryGirl.create(:plan, workflow_state: "awaiting_review") }
    let(:creator) { FactoryGirl.create(:user) }
    
    before do
      plan.update(creator: creator)
    end
    
    scenario "admin can request a revision" do
      
      sign_in(admin)
      visit "/plans/#{plan.id}"

      expect { 
        click_link "REQUEST REVISION"
      }.to change{ Plan.with_being_reviewed_state.count }.by(1)

      email = find_email(creator.email)
      expect(email).to_not be_nil
      expect(email).to have_body_text("needs revision")
    end
    
  end

  context "approve plan" do
    
    let(:plan) { FactoryGirl.create(:plan, workflow_state: "being_reviewed") }
    let(:creator) { FactoryGirl.create(:user) }
    
    before do
      plan.update(creator: creator)
    end
    
    scenario "admin can approve a plan", js: true do

      count = Plan.where(workflow_state: "accepted").count
      sign_in(admin)
      visit "/plans/#{plan.id}"

      expect { 
        click_link "APPROVE PLAN"
      }.to change{ Plan.with_accepted_state.count }.by(1)

      email = find_email(creator.email)
      expect(email).to_not be_nil
      expect(email).to have_body_text("has been approved")
    end

  end
end
