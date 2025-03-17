Feature: Instructor creates a custom template
  As an instructor
  I want to create reusable templates
  So that I can quickly build assignments or modules

  Background:
    Given I am logged in as an instructor

  Scenario: Successfully create a custom template
    Given I am on the instructor home page
    When I click on "Add Question"
    And I select "Velocity" from "Select Topic"
    And I select "Definition" from "Select Type"
    And I fill in "Question Template Text" with "My Custom Template"
    And I fill in "Equation" with "F / m"
    And I fill in "Variables (comma separated)" with "F, m"
    And I fill in "Answer Format" with "F / m"
    And I press on the button: "Create"
    Then I should see the string "Question template created successfully!"