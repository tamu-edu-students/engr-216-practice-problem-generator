Feature: Randomized Numbers
    As a instructor
        I want the variables to be within specified ranges and with specified numbers of decimal places
        So that I know the questions are realistic to what I will be putting on my exam

    Background:
        Given a predefined question exists
        And I am logged in with a valid tamu email
        And I visit the practice problems page
        And I select topic "Velocity"
        And I select question type "Free Response"
        And I press "Submit"
        Then I should be on the problem generation page

    Scenario: Generated random values are within specified ranges and formatting
        When I view the problem
        Then the problem text should display values for "u" and "a" formatted with 1 and 2 decimal places respectively
        And the problem text should display values for "a" and "t" formatted with 2 and 3 decimal places respectively
        And the value for "t" should be between 20.0 and 30.0
        And the value for "u" should be between 1.0 and 10.0
        And the value for "a" should be between 10.0 and 20.0