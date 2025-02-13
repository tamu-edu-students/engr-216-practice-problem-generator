Feature: Student View Personal Progress

    As a student
    So that I can see what areas I need to work on
    I want to be able to view the questions I got right and wrong

    Background:
        Given I am logged in

    Scenario: Student wants to view question progress
        Given the following submissions exist:
            | Topic    | Question       | Correct? |
            | Velocity  | What is gravity? | false  |
            | Velocity  | What is gravity? | false  |
            | Velocity  | What is gravity? | false  |
            | Velocity  | What is gravity? | true  |
            | Acceleration  | What is gravity? | true |
            | Acceleration     | What is the formula for acceleration | false  |
            | Acceleration     | What is the formula for acceleration | false  |
            | Acceleration     | What is the formula for acceleration | true  |
        When I navigate to the progress page
        Then I should see my overall performance
        And I should see my performance by topic
