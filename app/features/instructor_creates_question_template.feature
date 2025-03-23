Feature: Instructor creates a custom template
  As an instructor
  I want to create reusable templates
  So that I can quickly build assignments or modules

  Background:
    Given I am logged in as an instructor

  Scenario: Instructor fills in complete template details
    Given I am on the instructor home page
    When I click on "Add Question"
    And I select "Velocity" from "Select Topic"
    And I select "Definition" from "Select Type"
    And I fill in the new custom template form with:
      | Template Text      | A car starts with an initial velocity of \(a\) and accelerates at a rate \(b\). What is the final velocity? |
      | Equation           | a + b * t                                                                                                             |
      | Variables          | a, b, t                                                                                                               |
      | Answer Format      | Final velocity                                                                                                        |
      | Round Decimals     | 2                                                                                                                     |
      | Variable Ranges    | 1-10, 10-20, 5-15                                                                                                     |
      | Variable Decimals  | 2, 3, 1                                                                                                               |
      | Explanation        | Final velocity is calculated as the initial velocity plus the product of acceleration and time.                       |
    And I press "Create"
    Then I should see "Question template created successfully!"