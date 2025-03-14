Feature: Student selects an instructor
  As a student user
  I want to view my profile
  And optionally assign an instructor to my account
  So that my instructor can see my progress

  Background:
    Given I am logged in as a student

  Scenario: View my profile
    When I visit my profile page
    Then I should see b "Howdy" in the page content
    And I should see b "No instructor selected"

  Scenario: Successfully save a valid instructor
    Given an instructor user exists
    When I visit my profile page
    And I select that instructor from the dropdown
    And I press star "Save Instructor"
    Then I should see b "Instructor saved successfully!"
    And I should see the instructor's name in my profile

  Scenario: Fail to save an instructor when none selected
    Given an instructor user exists
    When I visit my profile page
    And I do NOT select any instructor from the dropdown
    And I press star "Save Instructor"
    Then I should see b "Failed to save instructor."
    And I should see b "No instructor selected"