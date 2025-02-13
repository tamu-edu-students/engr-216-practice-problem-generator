Feature: Practice Test Functionality

    As a user
    So that I can take a ENGR 216 practice test
    I want to access a system that allows me to attempt and submit a practice test with feedback

    Background: 
        Given a predefined question exists

    Scenario: Access a practice test and submit a practice test
        Given I am logged in with a valid tamu email
        And I visit the practice tests page
        When I select the topics "Velocity" and "Acceleration"
        And I select the question types "Definition" and "Free Response"
        And I submit the form
        Then I should be redirected to the practice test page
        When I answer all the questions
        And I submit my practice exam
        Then I should get a message saying "Test submitted"
        And I should see my score
        And I should receive feedback on my test answers