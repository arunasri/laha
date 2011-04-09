Feature: Forgot password

  Scenario: forgot password
    Given a user exists with an email of "john@example.com"
    When I go to the home page
    When I follow "Login"
    When I follow "Forgot password"
    When I fill in "user_email" with "john@example.com"
    When I press "Email me password"
    Then I should see custom forgot password message

  Scenario: forgot password with no valid email
    Given a user exists with an email of "john@example.com"
    When I go to the home page
    When I follow "Login"
    When I follow "Forgot password"
    When I fill in "user_email" with "john@example.com_invalid"
    When I press "Email me password"
    Then I should see "There is no user associated with the given email. Please try again."
