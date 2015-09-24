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
    super("#{Rails.root}/tmp/phantomjs/#{@index}.jpg", full: true)
  end

  def post_comment(body)
    first("a.comment").click
    
    within ".new-comment-area" do
      find("textarea").set body
      click_on "SUBMIT"
    end
  end

  def carrierwave_configured?
    ! CarrierWave::Uploader::Base.fog_directory.blank?
  end

  def uploaded_file_url
    "http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}/robots.txt"
  end

  def fake_direct_upload
    input = "<input name=\"supplementary_document[file]\" value=\"#{uploaded_file_url}\" type=\"hidden\" />"
    script = "$(\"input[type=file]\").replaceWith('#{input}');"
    page.evaluate_script script
  end
  
end

RSpec.configuration.include HelperMethods, :type => :acceptance
