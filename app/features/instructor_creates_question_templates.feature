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
      | 3       | Definition          |

  Scenario: Instructor successfully creates an equation-based template
    When I navigate to the "Custom Template" page
    And I select "Equation-Based" as Question Type
    And I press "Continue"
    Then I should be redirected to the "Equation Template" page
    And I fill in valid equation data
    Then I should be redirected to the "Instructor Home" page
    And I should see "Equation-based question template created!"
    And a new question with kind "equation" should exist

  Scenario: Instructor submits invalid equation
    When I navigate to the "Custom Template" page
    And I select "Equation-Based" as Question Type
    And I press "Continue"
    And I fill in invalid equation data
    Then I should be redirected to the "Equation Template" page
    And I should see "Invalid equation: "
    And no question is created

  Scenario: Instructor creates a dataset-based question
    When I navigate to the "Custom Template" page
    And I select "Dataset-Based" as Question Type
    And I press "Continue"
    Then I should be redirected to the "Dataset Template" page
    When I fill in valid dataset data
    Then I should be redirected to the "Instructor Home" page
    And I should see "Dataset-based question template created!"
    And a new question with kind "dataset" should exist

  Scenario: Instructor creates invalid dataset
    When I navigate to the "Custom Template" page
    And I select "Dataset-Based" as Question Type
    And I press "Continue"
    And I fill in invalid dataset data
    Then I should be redirected to the "Dataset Template" page
    And I should see "Dataset generator and answer type are required."
    And no question is created

  Scenario: Instructor creates a definition-based question
    When I navigate to the "Custom Template" page
    And I select "Definition-Based" as Question Type
    And I press "Continue"
    Then I should be redirected to the "Definition Template" page
    When I fill in valid definition data
    Then I should be redirected to the "Instructor Home" page
    And I should see "Definition-based question template created!"
    And a new question with kind "definition" should exist

  Scenario: Instructor creates invalid definition question
    When I navigate to the "Custom Template" page
    And I select "Definition-Based" as Question Type
    And I press "Continue"
    And I fill in invalid definition data
    Then I should be redirected to the "Definition Template" page
    And I should see "Answer can't be blank"
    And no question is created
