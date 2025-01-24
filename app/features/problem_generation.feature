Feature: Practice Problem Generation
  As a student,
  so that I can practice problems relevant to the selected concept,
  I want to be shown a randomly generated example problem after selecting a category.
  
  Background: 
    Given a predefined question exists

  Scenario: Unique questions within a set of problems
    Given I am logged in with a valid tamu email
    And I visit the practice problems page
    And I select topic "Velocity"
    And I select question type "Free Response"
    And I press "Submit"
    Then I should be on the problem generation page
    And I should see a randomly selected problem
    And I should see an input field to submit my answer

  Scenario: Displaying problem with randomized values
    Given I am logged in with a valid tamu email
    And I visit the practice problems page
    And I select topic "Velocity"
    And I select question type "Free Response"
    And I press "Submit"
    Then I should be on the problem generation page
    Given a problem with variables "u", "a", and "t"
    When the problem is displayed
    Then the values for "u", "a", and "t" should be randomly generated
    And the question text should include these values
