Feature: Instructor creates a new question template
  As an instructor
  I want to create a new question template
  So that I can add it to the database

  Background:
    Given I am logged in as an instructor

  Scenario: Successfully create a new question template
    Given I am on the custom template page
    When I fill in "Question Template Text" with "Sam applied \( F \) newtons of force to a ball that is \( m \) grams. What is the ball's acceleration?"
    And I fill in "Equation" with "F / m"
    And I fill in "Variables (comma separated)" with "F, m"
    And I fill in "Answer Format" with "a = F / m"

  Scenario: Navigate back to the instructor homepage
    Given I am on the custom template page
    When I click on "Back to Instructor Homepage"
    Then I should be on the instructor home page