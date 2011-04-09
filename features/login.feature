Feature: Login

  Scenario: login
    Given a user exists with an email of "john@example.com"
    When I go to the home page
    When I follow "Login"
    When I fill in "email" with "john@example.com"
    When I fill in "password" with "welcome"
    When I press "Login"
    Then I should see "Logged in"
    Then I should see "Logout"
