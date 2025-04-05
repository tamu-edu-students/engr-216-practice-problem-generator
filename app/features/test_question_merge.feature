Feature: Test Question Merge

  As a student
  I want the question generation and practice tests functionality to be merged
  So that a single unified function generates either an individual question or a practice test based on my selection

  Background:
    Given I am logged in as a student
    And I am on the practice generation page

  Scenario: Generate a single practice question when the "Practice Test" toggle is unchecked
    When I ensure the "Practice Test" toggle is unchecked
    And I click on "Generate Problem"
    Then I should see a generated question with an input field for my answer

  Scenario: Generate a practice test when the "Practice Test" toggle is checked
    When I check the "Practice Test" toggle
    And I click on "Generate Problem"
    Then I should be redirected to the practice test generation page
    And I should see a set of practice test questions with corresponding answer input fields