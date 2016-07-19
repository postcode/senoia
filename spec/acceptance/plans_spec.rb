require_relative "./acceptance_helper"

feature "Plan" do

  let(:plan) { FactoryGirl.create(:plan) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:test_user) { FactoryGirl.create(:user, roles: "user") }
  let(:guest_user) { FactoryGirl.create(:user, roles: "guest") }
  let(:permitter_type) { FactoryGirl.create(:permitter_type) }
  let!(:permitters) { 1.upto(3).map{ |i| FactoryGirl.create(:permitter, organization_type: permitter_type) }.sort_by(&:name) }
  let(:provider_type) { FactoryGirl.create(:provider_type) }
  let!(:providers) { 1.upto(3).map{ |i| FactoryGirl.create(:provider, organization_type: provider_type) }.sort_by(&:name) }


  context "admin create a new plan", js: true do

    before do
      @event_type = create(:event_type)
      sign_in(admin)
      visit "/plans/new"
      fill_in 'plan_name', with: Faker::Lorem.words.join(" ")
      select_from_chosen(@event_type.name, from: "plan_event_type_id")
      select_from_chosen(@event_type.name, from: "plan_event_type_id")
    end

    scenario "admin can create a basic plan" do
      expect{
        click_button "Continue"
      }.to change { Plan.count }.by(1)
    end
  end

  context "by a user", js: true do
    before do
      @event_type = create(:event_type)
      sign_in(test_user)
      visit "/plans/new"
      fill_in 'plan_name', with: Faker::Lorem.words.join(" ")
      select_from_chosen(@event_type.name, from: "plan_event_type_id")
    end

    scenario "can create a basic plan" do
      expect{
        click_button "Continue"
      }.to change { Plan.count }.by(1)
    end
  end

  context "by a guest", js: true do
    before do
      @event_type = create(:event_type)
      sign_in(guest_user)
      visit "/plans/new"
      fill_in 'plan_name', with: Faker::Lorem.words.join(" ")
      select_from_chosen(@event_type.name, from: "plan_event_type_id")
    end

    scenario "can create a basic plan" do
      expect{
        click_button "Continue"
      }.to change { Plan.count }.by(1)
    end
  end

  context "deleting medical assets" do
    let(:operation_period) { FactoryGirl.create(:operation_period) }
    let(:first_aid_station) { FactoryGirl.create(:first_aid_station) }
    let(:mobile_team) { FactoryGirl.create(:mobile_team) }
    let(:transport) { FactoryGirl.create(:transport) }
    let(:dispatch) { FactoryGirl.create(:dispatch) }

    before do
      operation_period.first_aid_stations << first_aid_station
      operation_period.mobile_teams << mobile_team
      operation_period.transports << transport
      operation_period.dispatchs << dispatch
      operation_period.save!
      plan.operation_periods << operation_period
      plan.save!
    end

    %w(first_aid_station mobile_team transport dispatch).each do |asset_type|

      scenario "admin can delete a #{asset_type.humanize.downcase}" do

        sign_in(admin)
        visit "/plans/#{plan.id}"

        asset = send(asset_type)
        expect(page).to have_content(asset.name)
        asset_row = find('td', :text => asset.name).find(:xpath, "..")

        within(asset_row) {
          check "Remove"
        }

        click_on "SAVE DRAFT"

        expect(page).to_not have_content(asset.name)
      end
    end
  end

  context "viewing an existing plan", js: true do
    let(:plan) { FactoryGirl.create(:plan, workflow_state: "under_review", organization: permitters[1]) }

    before do
      sign_in(admin)
      visit "/plans/#{plan.id}"
    end

    scenario "show permitting agencies contact info" do
      expect(page).to have_content plan.permitter.phone_number.phony_formatted(format: :national, spaces: ' ')
    end

    scenario "changing permitting agencies shows their contact info" do
      select_from_chosen(permitters.first.name, from: "plan_organization_id")
      expect(page).to have_content permitters.first.phone_number.phony_formatted(format: :national, spaces: ' ')
    end

    scenario "admin can add an operation period" do
      click_on "ADD OPERATIONAL PERIOD"
      expect(page).to have_content("OPERATIONAL PERIOD 2")
      click_on "Operational Period 2"
      fill_in "operation_period_start_date", with: "01/01/2020"
      fill_in "operation_period_end_date", with: "02/01/2020"
      fill_in "operation_period_attendance", with: 10000
      expect {
        click_link "Save"
        expect(page).to have_content("Create Duplicate Operation Period")
      }.to change { OperationPeriod.count }.by(1)
    end

    scenario "admin can remove an operation period" do
      click_on "Remove"
      expect(page).to_not have_selector(".operation-period-container .content")
    end

    scenario "admin can add a dispatch"  do
      click_on "ADD DISPATCH"
      dispatch_name = "Dispatch One"
      within '.dispatch_name' do
        fill_in "dispatch_name", with: dispatch_name
      end
      within ".dispatch_organization_id" do
        select_from_chosen(providers.first.name, from: "dispatch_organization_id")
      end

      expect {
        find(".save-dispatch", text: "Confirm This Asset").trigger("click")
        visit "/plans/#{plan.id}"
      }.to change{ Dispatch.count }.by(1)
    end

    scenario "admin can add a first aid station"  do
      click_link 'new_first_aid_station'
      first_aid_station_name = "2nd Aid Station"
      within '.new-first-aid-station' do
        fill_in 'first_aid_station_name', with: first_aid_station_name
      end

      within ".first_aid_station_organization_id" do
        select_from_chosen(providers.first.name, from: "first_aid_station_organization_id")
      end

      click_on "Confirm This Asset"
      expect {
        visit "/plans/#{plan.id}"
      }.to change{ FirstAidStation.count }.by(1)
    end

    scenario "admin can add a mobile team"  do
      click_on "ADD MOBILE TEAM"

      mobile_team_name = "Mobility One"
      within '.mobile_team_name' do
        find("input").set(mobile_team_name)
      end

      within ".mobile_team_organization_id" do
        select_from_chosen(providers.first.name, from: "mobile_team_organization_id")
      end

      click_on "Confirm This Asset"

      expect {
        visit "/plans/#{plan.id}"
      }.to change{ MobileTeam.count }.by(1)
    end

    scenario "admin can add a transport"  do
      click_on "ADD TRANSPORT"

      transport_name = "Transport One"
      within '.transport_name' do
        find("input").set(transport_name)
      end

      within ".transport_organization_id" do
        select_from_chosen(providers.first.name, from: "transport_organization_id")
      end
      click_on "Confirm This Asset"

      expect {
        visit "/plans/#{plan.id}"
      }.to change{ Transport.count }.by(1)
    end

  end

  context "request revision", js: true do

    let(:plan) { FactoryGirl.create(:plan, workflow_state: "under_review") }
    let(:creator) { FactoryGirl.create(:user) }

    before do
      plan.update(creator: creator)
    end

    scenario "admin can request a revision" do

      sign_in(admin)
      visit "/plans/#{plan.id}"

      expect {
        click_link "REQUEST REVISION"
      }.to change{ Plan.with_revision_requested_state.count }.by(1)
    end

  end

  context "approve plan", js: true do

    let(:plan) { FactoryGirl.create(:plan, workflow_state: "revision_requested") }
    let(:creator) { FactoryGirl.create(:user) }

    before do
      plan.update(creator: creator)
      sign_in(admin)
      visit "/plans/#{plan.id}"
    end

    scenario "admin can approve a plan" do
      expect {
        click_link "APPROVE PLAN"
      }.to change{ Plan.with_approved_state.count }.by(1)

      email = find_email(creator.email)
      expect(email).to_not be_nil
      expect(email).to have_body_text("has been approved")
    end

    scenario "the approval date is updated" do
      expect {
        click_link "APPROVE PLAN"
      }.to change{ Plan.with_approved_state.count }.by(1)
      visit "/plans/#{plan.id}"
      p plan.reload
      expect(page).to have_content "Plan approved on: #{plan.reload.approval_date}"
      expect(plan.reload.approval_date).to_not eq nil
    end


    context "with outstanding comments" do

      before do
        create(:comment_on_event_type, commentable: plan)
        visit "/plans/#{plan.id}"
      end

      scenario "admin cannot approve the plan" do
        expect(page).to_not have_content("APPROVE PLAN")
      end

      scenario "admin can resolve the comments and then approve the plan", js: true do
        click_on "RESOLVE"
        expect(page).to_not have_content("RESOLVE")
        expect(page).to have_content("APPROVE PLAN")

        expect {
          click_link "APPROVE PLAN"
        }.to change{ Plan.with_approved_state.count }.by(1)
      end

    end
  end

  context "clone an operation period", js: true do

    let(:plan) { create(:plan_under_review) }

    before do
      @operation_period = plan.operation_periods.first
      @operation_period.first_aid_stations << create(:first_aid_station)
      @operation_period.mobile_teams << create(:mobile_team)
      @operation_period.transports << create(:transport)
      @operation_period.dispatchs << create(:dispatch)

      sign_in(admin)
      visit "/plans/#{plan.id}"
    end

    scenario "admin can clone an operation period", js: true do
      click_on "Create Duplicate Operation Period"
      expect(page).to have_selector("#operation-period-tabs li", count: 2)
      click_on "Operational Period 2"

      cloned_attendance = find(".plan_operation_periods_attendance input").value
      expect(cloned_attendance).to eq plan.operation_periods.first.attendance.to_s

      expect(page).to have_content(@operation_period.first_aid_stations.first.name)
      expect(page).to have_content(@operation_period.mobile_teams.first.name)
      expect(page).to have_content(@operation_period.transports.first.name)
      expect(page).to have_content(@operation_period.dispatchs.first.name)
    end

  end

  context "when there are two operation periods" do

    before do
      plan.operation_periods << create(:operation_period)
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

      within ".first_aid_station_organization_id" do
        select providers.first.name, from: "first_aid_station_organization_id"
      end

      click_on "Confirm This Asset"

      visit "/plans/#{plan.id}"
      find("a[href='#panel2']").click
      expect(page).to have_content(first_aid_station_name)
    end
  end

  context "when a plan is approved" do
    let(:approved_plan) { FactoryGirl.create(:approved_plan, creator: test_user) }
    let(:group_member) { create(:user) }
    let(:notification_group) { create(:notification_group, notification_type: "plan.approved") }
    let(:document) { create(:supplementary_document, email: true, parent: approved_plan, file: "https://github.com/postcode/senoia/blob/master/README.rdoc") }

    before do
      notification_group.members << group_member
      sign_in(admin)
      visit "/plans/#{approved_plan.id}"
    end

    scenario "an admin can see the 'email approved plan' button" do
      expect(page).to have_content 'Email Approval Notification'
    end

    scenario "an admin can send an email to the plan approval group" do
      click_link 'Email Approval Notification'
      email = find_email(group_member.email)
      expect(email).to_not be_nil
      expect(email).to have_body_text("approved")
    end

    scenario "an admin can send an email to the plan approval group and it will contain a pdf of the plan" do
      click_link 'Email Approval Notification'
      email = find_email(group_member.email)
      expect(email).to_not be_nil
      expect(email.attachments.map(&:filename).select{ |name| name == "#{approved_plan.name}.pdf"}.include?("#{approved_plan.name}.pdf")).to eq true
    end
  end
end
