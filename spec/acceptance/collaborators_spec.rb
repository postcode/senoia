require_relative "acceptance_helper"

feature "Collaborators" do

  let(:admin) { FactoryGirl.create(:admin) }
  let(:plan) { FactoryGirl.create(:plan, workflow_state: "awaiting_review") }

  context "Admin", js: true do
    
    background do
      @collaborator = plan.plan_users.create(user: FactoryGirl.create(:user), role: "view").user
      @user = FactoryGirl.create(:user)
      sign_in(admin)
      visit "/plans/#{plan.id}"
    end

    scenario "adds a collaborator" do
      click_on "ADD USERS"
      
      find("#plan_view_id_#{@user.id}").set(true)
      find("#new-plan-user-submit").click

      expect(page).to have_css("input[value='#{@user.email}']")
      
      click_on "SAVE DRAFT"

      expect(find("fieldset", text: "COLLABORATORS")).to have_content(@user.email)
    end

    scenario "removes a collaborator" do
      within find("fieldset", text: "COLLABORATORS") do
        within find("tr", text: @collaborator.email) do
          click_on "Remove"
        end
      end

      expect(find("fieldset", text: "COLLABORATORS")).to_not have_content(@collaborator.email)
    end
    
  end

end
