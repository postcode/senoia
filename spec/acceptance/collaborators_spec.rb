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

    scenario "removes a collaborator" do
      within find("#users_table") do
        within find("tr", text: @collaborator.email) do
          click_on "Remove"
        end
      end

      expect(find("#users_table")).to_not have_content(@collaborator.email)
    end

    scenario "cannot invite a collaborator without an email" do
      click_on "ADD USERS"
      find("#invitation-email").set("not an email")
      click_on "Invite"
      expect(page).to have_content("Email is invalid")
    end

    scenario "collaborator can view a plan" do
      sign_out
      sign_in(@collaborator)
      visit "/plans/#{plan.id}"
      expect(find(".collaborators")).to have_content(@user_email)
    end

    scenario "invites a collaborator", js: true do
      @user_email = Faker::Internet.email
      @user_name = Faker::Name.name

      click_on "ADD USERS"

      find("#invitation-email").set(@user_email)
      click_on "Invite"

      expect(page).to have_content("Invitation sent")
      sign_out

      open_email(@user_email)
      click_email_link_matching(/sign_up/)

      reset_mailer

      password = Faker::Internet.password
      fill_in "Email", with: @user_email
      fill_in "user_name", with: @user_name
      fill_in "user_phone_number", with: Faker::PhoneNumber.phone_number
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: password
      click_button "Sign Up"

      expect(page).to have_content("confirmation link")

      open_email(@user_email)
      click_email_link_matching(/confirm/)

      fill_in "Email", with: @user_email
      fill_in "Password", with: password

      within ".form-actions" do
        click_on "Login"
      end

      visit "/plans"
      click_on "#{plan.name}"
      expect(find(".collaborators")).to have_content(@user_email)
    end
  end

end
