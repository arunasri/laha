Feature: change password

  Scenario: change password
    Given I am logged in
    When I follow "John Vanderbilt"
    When I follow "Change password"
    Then I should see custom message regarding email has been sent
