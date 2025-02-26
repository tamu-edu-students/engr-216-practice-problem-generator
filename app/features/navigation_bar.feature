Feature: Navigation Bar

  Scenario: Display navigation bar
    Given I am on any page of the application
    When the page loads
    Then I should see a navigation bar at the top of the screen

  Scenario: Navigation bar contains all relevant links
    Given I am on any page of the application
    When I view the navigation bar
    Then I should see links to "Home", "Profile", and "Practice"

  Scenario: Clicking on a navigation link routes to the correct page
    Given I am on any page of the application
    When I click on the "Home" link in the navigation bar
    Then I should be redirected to the "Home" page

  Scenario: Active page is highlighted in the navigation bar
    Given I am on the "Home" page
    When I view the navigation bar
    Then the "Home" link should be visually highlighted