require_relative "./acceptance_helper"

feature "Users" do

  context "User" do
    let(:user) { create(:user) }

    background do
      sign_in user
    end

    context "updates" do

      background do
        visit "/"
        click_on user.to_s
      end

      scenario "updates their name" do
        fill_in "Name", with: (new_name = Faker::Name.name)
        fill_in "Current password", with: user.password
        click_on "Update"
        expect(page).to have_content new_name
      end

      scenario "their phone number" do
        fill_in "user_phone_number", with: (new_phone_number = Faker::PhoneNumber.phone_number)
        fill_in "Current password", with: user.password
        click_on "Update"
        click_on user.to_s
        expect(page).to have_selector("input[value='#{PhonyRails.normalize_number(new_phone_number, default_country_code: 'US')}']")
      end
    end

    context "cannot" do

      let(:other_user) { create(:user) }

      scenario "edit another user's profile" do
        visit "/users_admin/#{other_user.id}/edit"
      end

      scenario "view the user index" do
        visit "/users_admin"
      end

      scenario "create a new user" do
        visit "/users_admin/new"
      end

      scenario "view the user edit page" do
        visit "/users_admin/#{user.id}/edit"
      end

      after do
        expect(page).to have_content "not authorized"
      end
    end

  end

  context "Admin" do

    let(:admin) { create(:admin) }
    let(:user) { create(:user) }

    background do
      sign_in admin
    end

    scenario "can edit another user's profile" do
      visit "/users_admin/#{user.id}/edit"
      fill_in "Name", with: (new_name = Faker::Name.name)
      click_on "Save"
      expect(page).to have_content new_name
    end

    scenario "views the user index" do
      visit "/users_admin"
      expect(page).to have_content "ALL USERS"
    end

    scenario "creates a new user", js: true do
      visit "/users_admin"
      click_on "Create New User"
      fill_in "Name", with: Faker::Name.name
      fill_in "Email", with: Faker::Internet.email
      fill_in "Phone number", with: Faker::PhoneNumber.phone_number
      select "Event Producer", from: "Roles"
      fill_in "user_password", with: (password = Faker::Internet.password)
      fill_in "user_password_confirmation", with: password
      click_on "Save"
    end

  end

  context "Guest" do

    scenario "signs up" do
      visit "/"
      click_on "Sign Up"
      fill_in "Name", with: Faker::Name.name
      fill_in "Email", with: Faker::Internet.email
      fill_in "Phone number", with: Faker::PhoneNumber.phone_number
      fill_in "user_password", with: (password = Faker::Internet.password)
      fill_in "user_password_confirmation", with: password
      click_button "Sign Up"
      expect(page).to have_content("activate your account")
      expect(User.last.roles).to include(:user)
    end

  end

end
