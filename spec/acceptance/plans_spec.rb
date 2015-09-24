require_relative "./acceptance_helper"

feature "Plan" do
  
  let(:plan) { FactoryGirl.create(:plan) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:permitters) { 1.upto(3).map{ |i| FactoryGirl.create(:permitter) }.sort_by(&:name) }

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
      
      expect(page).to have_content plan.permitter.phone_number
      
      select(permitters.first.name, from: "plan_permitter_id")
      
      expect(page).to have_content permitters.first.phone_number
      
    end

    scenario "admin can add an operation period", js: true do
      click_on "ADD OPERATIONAL PERIOD"
      expect(page).to have_content("OPERATIONAL PERIOD 2")
      click_on "Operational Period 2"
      fill_in "operation_period_start_date", with: "01/01/2020 08:00 am"
      fill_in "operation_period_end_date", with: "02/01/2020 08:00 am"
      expect { 
        find(".save-operation-period").trigger("click")
        expect(page).to have_content("Clone")
      }.to change { OperationPeriod.count }.by(1)
    end

    scenario "admin can remove an operation period", js: true do
      click_on "Remove"
      expect(page).to_not have_selector(".operation-period-container .content")
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
      click_link 'new_first_aid_station'
      
      first_aid_station_name = "2nd Aid Station"
      within '.first_aid_station_name' do
        fill_in 'Name', with: first_aid_station_name
      end
      expect { 

        click_on "Add First Aid Station"

        expect(page).to have_content first_aid_station_name
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
    end
    
  end

  context "approve plan", js: true do
    
    let(:plan) { FactoryGirl.create(:plan, workflow_state: "being_reviewed") }
    let(:creator) { FactoryGirl.create(:user) }
    
    before do
      plan.update(creator: creator)
    end
    
    scenario "admin can approve a plan" do
      sign_in(admin)
      visit "/plans/#{plan.id}"

      expect { 
        click_link "APPROVE PLAN"
      }.to change{ Plan.with_approved_state.count }.by(1)

      email = find_email(creator.email)
      expect(email).to_not be_nil
      expect(email).to have_body_text("has been approved")
    end

    context "with outstanding comments" do

      before do
        create(:comment_on_event_type, commentable: plan)
        sign_in(admin)
        visit "/plans/#{plan.id}"
      end
    
      scenario "admin cannot approve the plan" do
        expect(page).to_not have_content("APPROVE PLAN")
      end

      scenario "admin can resolve the comments and then approve the plan", js: true do
        click_on "RESOLVE"
        expect(page).to have_content("APPROVE PLAN")

        expect { 
          click_link "APPROVE PLAN"
        }.to change{ Plan.with_approved_state.count }.by(1)
      end
      
    end
  end

  context "clone an operation period" do

    let(:plan) { create(:plan_awaiting_review) }

    before do
      plan.operation_periods << create(:operation_period)

      @operation_period = plan.operation_periods.first
      @operation_period.first_aid_stations << create(:first_aid_station)
      @operation_period.mobile_teams << create(:mobile_team)
      @operation_period.transports << create(:transport)
      @operation_period.dispatchs << create(:dispatch)
      
      sign_in(admin)
      visit "/plans/#{plan.id}"
    end
    
    scenario "admin can clone an operation period", js: true do
      click_on "Clone"
      expect(page).to have_selector("#operation-period-tabs li", count: 2)
      click_on "Operational Period 2"

      cloned_attendance = find(".plan_operation_periods_attendance input").value
      expect(cloned_attendance).to eq plan.operation_periods.first.attendance.to_s

      cloned_first_aid_station_name = find(".plan_operation_periods_first_aid_stations_name input").value
      expect(cloned_first_aid_station_name).to eq @operation_period.first_aid_stations.first.name

      cloned_mobile_team_name = find(".plan_operation_periods_mobile_teams_name input").value
      expect(cloned_mobile_team_name).to eq @operation_period.mobile_teams.first.name

      cloned_transport_name = find(".plan_operation_periods_transports_name input").value
      expect(cloned_transport_name).to eq @operation_period.transports.first.name

      cloned_dispatch_name = find(".plan_operation_periods_dispatchs_name input").value
      expect(cloned_dispatch_name).to eq @operation_period.dispatchs.first.name
    end

  end

  context "when there are two operation periods" do

    before do
      2.times { plan.operation_periods << create(:operation_period) }
      sign_in(admin)
      visit "/plans/#{plan.id}"
    end
    
    scenario "admin can add a first aid station to the second", js: true  do
      find("a[href='#panel2']").click
      
      click_link 'new_first_aid_station'
      
      first_aid_station_name = "2nd Aid Station"
      within '.first_aid_station_name' do
        fill_in 'Name', with: first_aid_station_name
      end

      click_on "Add First Aid Station"

      expect(page).to have_content first_aid_station_name

      visit "/plans/#{plan.id}"
      find("a[href='#panel2']").click
      expect(page).to have_selector("#panel2 input[value='#{first_aid_station_name}']")
    end
  end


end
