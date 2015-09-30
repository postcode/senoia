require_relative "./acceptance_helper"

feature "Users" do

  context "User" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    
    background do
      sign_in user
    end

    scenario "updates their name" do
      visit "/users/#{user.id}/edit"
      fill_in "Name", with: (new_name = Faker::Name.name)
      click_on "Save"
      expect(page).to have_content new_name
    end

    scenario "updates their phone number" do
      visit "/users/#{user.id}/edit"
      fill_in "Phone number", with: (new_phone_number = Faker::PhoneNumber.phone_number)
      click_on "Save"
      visit "/users/#{user.id}/edit"
      expect(page.body).to match Regexp.new(new_phone_number)
    end

    scenario "cannot edit another user's profile" do
      visit "/users/#{other_user.id}/edit"
      expect(page).to have_content "not authorized"
    end

    scenario "cannot view the user index" do
      visit "/users"
      expect(page).to have_content "not authorized"
    end

    scenario "cannot create a new user" do
      visit "/users/new"
      expect(page).to have_content "not authorized"
    end
    
  end

  context "Admin" do

    let(:admin) { create(:admin) }
    let(:user) { create(:user) }
    
    background do
      sign_in admin
    end
    
    scenario "can edit another user's profile" do
      visit "/users/#{user.id}/edit"
      fill_in "Name", with: (new_name = Faker::Name.name)
      click_on "Save"
      expect(page).to have_content new_name
    end

    scenario "views the user index" do
      visit "/users"
      expect(page).to have_content "ALL USERS"
    end

    scenario "creates a new user" do
      visit "/users"
      click_on "Create New User"
      fill_in "Name", with: Faker::Name.name
      fill_in "Email", with: Faker::Internet.email
      fill_in "Phone number", with: Faker::PhoneNumber.phone_number
      select "user", from: "Roles"
      fill_in "user_password", with: (password = Faker::Internet.password)
      fill_in "user_password_confirmation", with: password
      click_on "Save"
    end

  end

  context "Guest" do
    
    scenario "signs up" do
      visit "/"
      click_on "Login"
      click_on "Sign up"
      fill_in "Name", with: Faker::Name.name
      fill_in "Email", with: Faker::Internet.email
      fill_in "Phone number", with: Faker::PhoneNumber.phone_number
      fill_in "user_password", with: (password = Faker::Internet.password)
      fill_in "user_password_confirmation", with: password
      click_on "Sign Up"
      expect(page).to have_content("activate your account")
    end
    
  end
  
end
