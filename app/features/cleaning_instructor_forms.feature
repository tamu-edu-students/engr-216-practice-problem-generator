Feature: Cleaning Instructor Forms

  As an instructor
  I want the add question template forms to include clear explanations for each field
  And to ensure that free response, dataset, and multiple choice questions all submit properly

  Background:
    Given I am logged in as an instructor

  Scenario: Submit a clean Free Response question template
    When I navigate to the "Custom Template" page
    And I fill in valid free response template data with explanations for each box
    And I submit the free response question template form
    Then I should see a confirmation message "Question template created!"
    And a new question with kind "Free Response" should exist

  Scenario: Submit a clean Dataset question template
    When I navigate to the dataset template form
    And I fill in valid dataset template data with clear explanations for each box
    And I submit the dataset question template form
    Then I should see a confirmation message "Dataset-based question template created!"
    And a new question with kind "dataset" should exist

  Scenario: Submit a clean Multiple Choice question template
    When I navigate to the multiple choice template form
    And I fill in valid multiple choice template data with explanations for each input field
    And I submit the multiple choice question template form
    Then I should see a confirmation message "Multiple choice question template created!"
    And a new question with kind "multiple_choice" should exist