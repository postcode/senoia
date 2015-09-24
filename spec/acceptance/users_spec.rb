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
      expect(page).to have_content new_phone_number
    end

    scenario "cannot edit another user's profile" do
      visit "/users/#{other_user.id}/edit"
      expect(page).to have_content "not authorized"
    end

    scenario "cannot view the user index" do
      visit "/users"
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

  end
  
end
