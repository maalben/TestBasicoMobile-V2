require_relative 'android_login_page'
require_relative 'ios_login_page'

class LoginPage
  def initialize(driver, wait)
    @driver = driver
    @wait = wait
    @platform = driver.caps[:platformName].to_s.downcase
    @page = if @platform == 'ios'
              IOSLoginPage.new(driver, wait)
            else
              AndroidLoginPage.new(driver, wait)
            end
  end

  def username_field
    @page.username_field
  end

  def password_field
    @page.password_field
  end

  def login_button
    @page.login_button
  end

  def home_page_element
    @page.home_page_element
  end
end
