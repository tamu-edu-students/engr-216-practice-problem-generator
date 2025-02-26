Feature: Explanation of Correctness

  Background: 
    Given I am logged in as a student

  Scenario: Understanding the correct answer
    When I am on the question explanation page
    Then I should see the Correct Answer
    And I should see the explanation for this answer

  Scenario: Answering the question incorrectly
    Given I answered a question incorrectly
    And I am on the question explanation page
    Then I should see the Correct Answer
    And I should see Incorrect
    And I should also see the explanation of the correct answer