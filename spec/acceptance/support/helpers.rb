module HelperMethods
  def sign_in(user)
    visit "/users/sign_in"
    fill_in "user_email",    with: user.email
    fill_in "user_password", with: user.password
    click_button "Login"
  end

  def sign_out
    visit "/"
    click_link "Logout"
  end

  def save_screenshot
    @index ||= 0
    @index = @index + 1
    filename = "#{Rails.root}/tmp/phantomjs/#{@index}.jpg"
    super(filename, full: true)
  end

  def post_comment(body)
    first("a.comment").click
    
    within ".new-comment-area" do
      find("textarea").set body
      click_on "SUBMIT"
    end
  end

end

RSpec.configuration.include HelperMethods, :type => :acceptance
