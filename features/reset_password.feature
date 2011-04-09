Feature: reset password

  Scenario: reset password
    Given a user exists with an email of "john@example.com"
    When I go to the logout page
    When I visit custom reset password link
    Then I should see "Reset password"
    When I fill in "password" with "welcome99"
    When I press "Set new password"
    Then I should see "Your password has been changed"
    When I follow "Logout"
    When I follow "Login"
    When I fill in "email" with "john@example.com"
    When I fill in "password" with "welcome99"
    When I press "Login"
    Then I should see "Logged in"

  Scenario: reset password with empty password
    Given a user exists with an email of "john@example.com"
    When I go to the logout page
    When I visit custom reset password link
    Then I should see "Reset password"
    When I fill in "password" with ""
    When I press "Set new password"
    Then I should see "password can't be blank"
