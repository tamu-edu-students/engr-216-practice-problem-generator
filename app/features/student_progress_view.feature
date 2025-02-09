Feature: Student View Personal Progress

    As a student
    so that I can see what area I need to work on
    I want to be able to view the questions I got right and wrong

    Background:
        Given I am logged in as a student
    
    Scenario: Student wants to view question progress
        When the Student navigates to progress page
        Then they should see their progress for each topic type
