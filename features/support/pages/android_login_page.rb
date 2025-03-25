class AndroidLoginPage
  def initialize(driver, wait)
    @driver = driver
    @wait = wait
  end

  def username_field
    @wait.until { @driver.find_element(:xpath, '//android.widget.EditText[@content-desc="test-Username"]') }
  end

  def password_field
    @driver.find_element(:xpath, '//android.widget.EditText[@content-desc="test-Password"]')
  end

  def login_button
    @driver.find_element(:xpath, '//android.view.ViewGroup[@content-desc="test-LOGIN"]')
  end

  def home_page_element
    @wait.until { @driver.find_element(:xpath, '//*[@content-desc="test-Cart drop zone"]') }
  end
end