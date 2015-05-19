module HelperMethods
  def sign_in(user)
    visit "/users/sign_in"
    fill_in "user_email",    with: user.email
    fill_in "user_password", with: user.password
    click_button "Login"
  end

  def sign_out(user)
    visit "/admin/users"
    click_link "Logout"
  end

end

RSpec.configuration.include HelperMethods, :type => :acceptance
