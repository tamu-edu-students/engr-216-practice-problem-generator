Feature: Practice Problem Generation
  As a student,
  so that I can practice problems relevant to the selected concept,
  I want to be shown a randomly generated example problem after selecting a category.
  
  Background: 
    Given a predefined question exists

  Scenario: Unique questions within a set of problems
    Given I am logged in with a valid tamu email
    And I visit the practice page
    And I select topic "Velocity"
    And I select question type "Free Response"
    And I press "Submit"
    Then I should be on the problem generation page
    And I should see a randomly selected problem
    And I should see an input field to submit my answer

  Scenario: Displaying problem with randomized values
    Given I am logged in with a valid tamu email
    And I visit the practice page
    And I select topic "Velocity"
    And I select question type "Free Response"
    And I press "Submit"
    Then I should be on the problem generation page
    Given a problem with variables "u", "a", and "t"
    When the problem is displayed
    Then the values for "u", "a", and "t" should be randomly generated
    And the question text should include these values

  Scenario: Displaying dataset problem with generated dataset values
    Given a predefined dataset question exists
    Given I am logged in with a valid tamu email
    And I visit the practice page
    And I select topic "Statistics"
    And I select question type "Free Response"
    And I press "Submit"
    Then I should be on the problem generation page
    When the problem is displayed
    Then I should see a list of numbers representing the dataset

  Scenario: Displaying median problem with generated dataset values
    Given a predefined median question exists
    Given I am logged in with a valid tamu email
    And I visit the practice page
    And I select topic "Statistics"
    And I select question type "Free Response"
    And I press "Submit"
    Then I should be on the problem generation page
    When the problem is displayed
    Then I should see a list of numbers representing the dataset

  Scenario: Displaying mode problem with generated dataset values
    Given a predefined mode question exists
    Given I am logged in with a valid tamu email
    And I visit the practice page
    And I select topic "Statistics"
    And I select question type "Free Response"
    And I press "Submit"
    Then I should be on the problem generation page
    When the problem is displayed
    Then I should see a list of numbers representing the dataset

  Scenario: Displaying range problem with generated dataset values
    Given a predefined range question exists
    Given I am logged in with a valid tamu email
    And I visit the practice problems page
    And I select topic "Statistics"
    And I select question type "Free Response"
    And I press "Submit"
    Then I should be on the problem generation page
    When the problem is displayed
    Then I should see a list of numbers representing the dataset

  Scenario: Displaying standard deviation problem with generated dataset values
    Given a predefined standard deviation question exists
    Given I am logged in with a valid tamu email
    And I visit the practice problems page
    And I select topic "Statistics"
    And I select question type "Free Response"
    And I press "Submit"
    Then I should be on the problem generation page
    When the problem is displayed
    Then I should see a list of numbers representing the dataset

  Scenario: Displaying variance problem with generated dataset values
    Given a predefined variance question exists
    Given I am logged in with a valid tamu email
    And I visit the practice problems page
    And I select topic "Statistics"
    And I select question type "Free Response"
    And I press "Submit"
    Then I should be on the problem generation page
    When the problem is displayed
    Then I should see a list of numbers representing the dataset


  Scenario: Displaying definition problem
    Given a predefined definition question exists
    Given I am logged in with a valid tamu email
    And I visit the practice page
    And I select topic "Velocity"
    And I select question type "Free Response"
    And I press "Submit"
    When I should be on the problem generation page
    When the problem is displayed
    Then I should see the definition question
