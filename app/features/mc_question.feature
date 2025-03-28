Feature: Practice Multiple Choice Questions

  As a user
  So that I can practice multiple choice questions
  I want to select multiple choice questions and solve them

  Background:
    Given I am logged in with a valid tamu email
    And the following multiple choice questions exist:
      | Topic             | Question        | Choices                         | Correct Choice |
      | Basic Arithmetic  | What is 2 + 2?  | 3,4,5,6                          | 4              |


  Scenario: Display and select answer choices for MCQ
    Given I have selected Multiple choice and Basic Arithmetic
    Then I should see four answer choices
    And I should be able to select one

  Scenario: Submit answer and see correct solution
    Given I have selected Multiple choice and Basic Arithmetic
    And I select the correct answer choice
    And I press submit
    Then I should see feedback indicating the answer was correct
    And I should see the correct answer explanation
