# frozen_string_literal: true

require_relative '../support/pages/login_page'

@driver = $driver

def login_page
  LoginPage.new(@driver, Selenium::WebDriver::Wait.new(timeout: 10))
end

Given('the user is on the login page') do
  # Espera hasta que el campo de usuario esté presente como señal de que la pantalla se cargó
  expect(login_page.username_field.displayed?).to be true
end

When('the user enters {string} into the username field') do |username|
  login_page.username_field.send_keys(username)
end

And('the user enters {string} into the password field') do |password|
  login_page.password_field.send_keys(password)
end

And('the user clicks the login button') do
  login_page.login_button.click
end

Then('the user should see the home page') do
  home_page_element = login_page.home_page_element
  expect(home_page_element.displayed?).to be true
end
