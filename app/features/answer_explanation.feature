Feature: Explanation of Correctness

  Background: 
    Given a predefined question exists
    And I am logged in with a valid tamu email
    And I visit the practice problems page
    And I select topic "Velocity"
    And I select question type "Free Response"
    And I press "Submit"
    Then I should be on the problem generation page

  Scenario: Understanding the correct answer
    And I input the correct solution
    When I click "Submit"
    Then I should see the explanation for this answer

  Scenario: Answering the question incorrectly
    And I input an incorrect solution
    When I click "Submit"
    Then I should see the explanation for this answer

  Scenario: Trying Another Problem
    And I input the correct solution
    When I click "Submit"
    When I click "Try Another Problem"
    Then I should be on the problem generation page