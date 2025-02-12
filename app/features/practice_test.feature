Feature: Practice Test Functionality

    As a user
    So that I can take a ENGR 216 practice test
    I want to access a system that allows me to attempt and submit a practice test with feedback
    
    Scenario: Access a practice test 
        Given I am a user
        And I am logged in
        When I go to the "Practice Tests" section
        Then I should see a list of available practice tests
        And I should be able to select a ENGR 216 practice test

    Scenario: Attempt and submit a practice test
        Given I am logged in
        And I have selected a ENGR 216 practice test
        When I start the test
        And I answer all the questions
        And I submit my answers
        Then I should get a message saying "Test submitted"
        And I should receive feedback on my test answers