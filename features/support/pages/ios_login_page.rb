class IOSLoginPage
  def initialize(driver, wait)
    @driver = driver
    @wait = wait
  end

  def username_field
    @driver.find_element(:accessibility_id, 'test-Username')
  end

  def password_field
    @driver.find_element(:accessibility_id, 'test-Password')
  end

  def login_button
    @driver.find_element(:accessibility_id, 'test-LOGIN')
  end

  def home_page_element
    @wait.until { @driver.find_element(:accessibility_id, 'test-Cart drop zone') }
  end
end