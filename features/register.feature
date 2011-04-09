Feature: Register

  Scenario: Register
    Given I go to the logout page
    When I go to the home page
    When I follow "Register"
    When I fill in "user_name" with "Jane Doe"
    When I fill in "user_email" with "jane@example.com"
    When I press "Register"
    Then I should see "Welcome"
    Then I should see "Logout"
