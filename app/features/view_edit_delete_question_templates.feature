Feature: View, Edit, and Delete Question Templates

  As an instructor
  I want to view all question templates and manage them by editing or deleting
  So that I can update the questions provided to students

  Background:
    Given I am logged in as an instructor
    And I have created some question templates

  Scenario: View all question templates
    When I navigate to the "Question Templates" page
    Then I should see "Question Templates" as the page header
    And I should see a list of all question templates
    And each question template should have an "Edit" button
    And each question template should have a "Delete" button

  Scenario: Edit a question template
    Given a question template exists with the text "Sample Equation Template"
    When I click the "Edit" button for the "Sample Equation Template" template
    Then I should be on the edit page for that question template
    And I update the template text to "Updated Equation Template"
    When I submit the changes
    Then I should see a confirmation message "Question template updated successfully"
    And the question template "Updated Equation Template" should be displayed in the list

  Scenario: Delete a question template
    Given a question template exists with the text "Obsolete Template"
    When I click the "Delete" button for the "Obsolete Template" template
    Then I should see a confirmation prompt
    When I confirm the deletion
    Then I should see a confirmation message "Question template deleted successfully"
    And the "Obsolete Template" should no longer be displayed in the list