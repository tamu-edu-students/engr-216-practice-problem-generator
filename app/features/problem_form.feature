Feature: Selecting topics and question types

  Scenario: User selects topics and question types in the problem form
    Given I am logged in with a valid tamu email
    And I visit the practice problems page
    When I select the topics "Velocity" and "Acceleration"
    And I select the question types "Definition" and "Free Response"
    And I submit the form
    Then I should be redirected to the problem generation page
    And I should see "Velocity" and "Acceleration"
    And I should see "Definition" and "Free Response"