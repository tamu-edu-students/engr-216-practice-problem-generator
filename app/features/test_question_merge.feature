Feature: Test Question Merge

  As a student
  I want the question generation and practice tests functionality to be merged
  So that a single unified function generates either an individual question or a practice test based on my selection

  Background:
    Given I am logged in as a student
    Given I visit the practice page
    Given a predefined question exists
    Given another predefined question exists

  Scenario: Generate a single practice question when the "Practice Test" toggle is unchecked
    Given I visit the practice page
    And I select topic "Velocity"
    And I select question type "Free Response"
    When I make sure Practice Test Mode is disabled
    And I submit the form
    Then I should be redirected to the problem generation page
    And I should see a randomly selected problem
    And I should see an input field to submit my answer

  Scenario: Generate a practice test when the "Practice Test" toggle is checked
    Given I visit the practice page
    And I select the topics "Velocity" and "Accuracy and precision of measurements, error propagation"
    And I select the question types "Definition" and "Free Response"
    And I enable Practice Test Mode
    And I submit the form
    Then I should be redirected to the practice test generation page
    Given I should see multiple randomly selected problems
    And I should see multiple input fields to submit my answers