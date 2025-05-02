Feature: Manage question templates
  As an instructor
  I want to view, filter, edit, and delete my question templates
  So I can keep my content up to date

  Background:
    Given I am logged in as an instructor
    And the following questions exist:
      | question_kind | template_text                  |
      | dataset       | Calculate the mean of this set |
      | equation      | Solve for x                    |

  Scenario: I see a list of all question templates
    When I visit the instructor questions page
    Then I should see "Calculate the mean of this set"
    And I should see "Solve for x"

  Scenario: I filter by question kind
    When I visit the instructor questions page
    And I select "Dataset" from the "question_kind" filter
    And I press "Filter"
    Then I should see "Calculate the mean of this set"
    And I should not see "Solve for x"

  Scenario: I edit a question
    When I visit the instructor questions page
    And I click "Edit" for "Solve for x"
    Then I should see "Edit Equation Question"
    When I edit in valid equation data
    And I press "Update Equation Question"
    Then I should see "Question updated successfully!"

  Scenario: I delete a question
    When I visit the instructor questions page
    And I click "Delete" for "Calculate the mean of this set"
    Then I should not see "Calculate the mean of this set"

  Scenario: I see a message if there are no questions
    Given there are no questions
    When I visit the instructor questions page
    Then I should see "No questions have been created yet."
