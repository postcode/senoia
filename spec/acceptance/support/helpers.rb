module HelperMethods
  def sign_in(user)
    visit "/users/sign_in"
    fill_in_login_information(user)
  end

  def sign_out
    visit "/"
    click_link "Logout"
  end

  def fill_in_login_information(user)
    fill_in "user_email",    with: user.email
    fill_in "user_password", with: user.password
    click_button "Login"
  end

  def save_screenshot
    @index ||= 0
    @index = @index + 1
    filename = "#{Rails.root}/tmp/phantomjs/#{@index}.jpg"
    super(filename, full: true)
  end

  def post_comment(body)
    expect(page).to have_selector("a.comment")
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

  def select_from_chosen(item_text, options)
    field = find("##{options[:from]}", visible: false)
    menu = nil
    count = 0
    until menu.present? || count > 5
      begin
        menu = find("##{field[:id]}_chosen")
      rescue Capybara::ElementNotFound => e
        p e
        count = count + 1
      end
    end
    menu.click
    menu_item = nil
    count = 0
    until menu_item.present? || count > 5
      begin
        menu_item = find("##{field[:id]}_chosen ul.chosen-results li", text: item_text)
      rescue Capybara::ElementNotFound => e
        p e
        count = count + 1
        menu.click
      end
    end
    menu_item.click
  end

end

RSpec.configuration.include HelperMethods, :type => :acceptance
