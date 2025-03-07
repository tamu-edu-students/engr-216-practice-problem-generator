Feature: Navigation Bar

  Scenario: Display navigation bar
    Given I am logged in with a valid tamu email
    When I am on any page of the application
    Then I should see a navigation bar at the top of the screen

  Scenario: Navigation bar contains links for student view
    Given I am logged in as a student
    And I am on any page of the application
    Then the student navigation bar should have links to "Home", "Profile", "Logout", "Problems", "Practice Tests", "Leaderboard", and "Progress"

  Scenario: Navigation bar contains links for instructor view
    Given I am logged in as an instructor
    And I am on any page of the application
    Then the instructor navigation bar should have links to "Home", "Profile", "Logout", "Custom Template", and "Student Progress Summary"

  Scenario: Navigation bar contains links for admin view
    Given I am logged in as an admin
    And I am on any page of the application
    Then the admin navigation bar should have links to "Home", "Profile", "Logout", and "View Accounts"

  Scenario: Clicking on a navigation link routes to the correct page
    Given I am logged in with a valid tamu email
    When I am on any page of the application
    When I click on the "Home" link in the navigation bar
    Then I should be redirected to the "Home" page

  Scenario: Active page is highlighted in the navigation bar
    Given I am logged in with a valid tamu email
    When I am on the "Home" page
    Then the "Home" link on the navigation bar should be bold and underlined