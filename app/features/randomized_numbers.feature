Feature: Randomized Numbers
    As a instructor
        I want the variables to be within specified ranges and with specified numbers of decimal places
        So that I know the questions are realistic to what I will be putting on my exam

    Background:
        Given I am logged in as a student
        And a predefined question exists
        And I navigate to the practice problems page
        And I select topic "Velocity"
        And I select question type "Free Response"
        And I press "Submit"

    Scenario: Generated random values are within specified ranges and formatting
        When I generate a new problem
        Then the problem text should display values for "a" and "b" formatted with 2 and 3 decimal places respectively
        And the value for "a" should be between 1.0 and 10.0
        And the value for "b" should be between 10.0 and 20.0