Feature: Instructor creates question templates

  Background:
    Given I am logged in as an instructor
    And the following topics exist:
      | topic_id | topic_name         |
      | 1        | Motion             |
    And the following types exist:
      | type_id | type_name          |
      | 1       | Free Response       |
      | 2       | Multiple Choice     |

  Scenario: Instructor successfully creates an equation-based template
    When I visit the equation template form
    And I fill in valid equation data
    And I press "Create Equation"
    Then I should be redirected to the instructor home page
    And I should see "Equation-based question template created!"
    And a new question with kind "equation" should exist

  Scenario: Instructor submits invalid equation
    When I visit the equation template form
    And I fill in an invalid equation
    And I press "Create Equation"
    Then I should see "Invalid equation"

  Scenario: Instructor creates a dataset-based question
    When I visit the dataset template form
    And I fill in valid dataset data
    And I press "Create Dataset Template"
    Then I should be redirected to the instructor home page
    And I should see "Dataset-based question template created!"
    And a new question with kind "dataset" should exist

  Scenario: Instructor creates a definition-based question
    When I visit the definition template form
    And I fill in valid definition data
    And I press "Create Definition"
    Then I should be redirected to the instructor home page
    And I should see "Definition-based question template created!"
    And a new question with kind "definition" should exist

  Scenario: Instructor submits definition without required fields
    When I visit the definition template form
    And I press "Create Definition"
    Then I should see "Both definition and term are required."
