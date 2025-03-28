Feature: Rounding Answers
    As a student
        I want the correct answer to be displayed with the proper number of decimal places
        So that I know the answer is rounded as required

    Background:
        Given I am logged in as a student
        And a predefined question exists
        And I navigate to the practice problems page
        And I select topic "Velocity"
        And I select question type "Free Response"
        And I press "Submit"

    Scenario: Displaying rounded solution with trailing zeros
        Then I should see the instruction "Round your answer to 3 decimal places"

    Scenario:
        And I input the correct solution
        When I click "Submit"
        And I should see the correct answer displayed in fixed decimal format