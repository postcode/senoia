require_relative "acceptance_helper"

feature "Collaborators" do

  let(:admin) { FactoryGirl.create(:admin) }
  let(:plan) { FactoryGirl.create(:plan, workflow_state: "under_review") }
  let(:invite_email_address) { Faker::Internet.email }

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

    scenario "cannot invite a collaborator without an email" do
      click_on "ADD USERS"
      find("#invitation-email").set("not an email")
      click_on "Invite"
      expect(page).to have_content("Email is invalid")
    end

    scenario "invites a collaborator" do

      click_on "ADD USERS"

      find("#invitation-email").set(invite_email_address)
      click_on "Invite"

      expect(page).to have_content("Invitation sent")
      sign_out

      open_email(invite_email_address)
      click_email_link_matching(/sign_up/)

      reset_mailer

      password = Faker::Internet.password
      fill_in "Email", with: invite_email_address
      fill_in "user_name", with: @collaborator.name
      fill_in "user_phone_number", with: Faker::PhoneNumber.phone_number
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: password
      click_button "Sign Up"

      expect(page).to have_content("confirmation link")

      open_email(invite_email_address)
      click_email_link_matching(/confirm/)

      visit "/users/sign_in"

      fill_in "Email", with: invite_email_address
      fill_in "Password", with: password

      within ".form-actions" do
        click_on "Login"
      end

      visit "/plans/#{plan.id}"
      save_and_open_page

      p User.find_by_email("#{invite_email_address}")
      p plan.plan_users
      click_link plan.name
      expect(find("fieldset", text: "COLLABORATORS")).to have_content(invite_email_address)
    end
  end

end
