Feature: Submit Solution Attempt

    As a student,
    so that I can test my understanding,
    I want to submit my attempt at solving a problem as a computed numeric value.

    Background: 
        Given a predefined question exists
        And I am logged in with a valid tamu email
        And I visit the practice problems page
        And I select topic "Velocity"
        And I select question type "Free Response"
        And I press "Submit"
        Then I should be on the problem generation page

    Scenario: Student submits correct answer
        And I input the correct solution
        When I click "Submit"
        Then I should see "Correct!"
    
    Scenario: Student submits incorrect answer
        And I input an incorrect solution
        When I click "Submit"
        Then I should see "Incorrect!"