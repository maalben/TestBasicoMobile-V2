Feature: Debug Test

  Scenario: Verify user can enter text and submit
    Given the user is on the login page
    When the user enters "standard_user" into the username field
    And the user enters "secret_sauce" into the password field
    And the user clicks the login button
    Then the user should see the home page