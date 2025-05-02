Feature: Cleaning Instructor Forms

  As an instructor
  I want the add question template forms to include clear explanations for each field
  And to ensure that free response, dataset, and multiple choice questions all submit properly

  Background:
    Given I am logged in as an instructor
    And the following topics exist:
      | topic_id | topic_name         |
      | 1        | Motion             |
    And the following types exist:
      | type_id | type_name          |
      | 1       | Free Response       |
      | 2       | Multiple choice     |
      | 3       | Definition          |

  Scenario: Submit a clean Equation multiple choice question template
    When I navigate to the "Custom Template" page
    And I select "Equation-Based" as Question Type
    And I press "Continue"
    Then I should be redirected to the "Equation Template" page
    And I select "Multiple choice" from Select Type
    And I fill in valid multiple choice equation data
    Then I should be redirected to the "Instructor Home" page
    And I should see "Equation-based question template created!"
    And a new question with kind "equation" and type "Multiple choice" should exist

  Scenario: Submit a clean Definition multiple choice question template
    When I navigate to the "Custom Template" page
    And I select "Definition-Based" as Question Type
    And I press "Continue"
    Then I should be redirected to the "Definition Template" page
    And I select "Multiple choice" from Select Type
    And I fill in valid multiple choice definition data
    Then I should be redirected to the "Instructor Home" page
    And I should see "Definition-based question template created!"
    And a new question with kind "definition" and type "Multiple choice" should exist

  Scenario: Instructor views student progress
    When I navigate to the "Student Progress" page
    Then I should see "Student Progress Summary"