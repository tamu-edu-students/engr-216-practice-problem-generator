Feature: Practice Test Functionality

    As a user
    So that I can take a ENGR 216 practice test
    I want to access a system that allows me to attempt and submit a practice test with feedback

    Background: 
        Given a predefined question exists
        Given another predefined question exists
        Given I am logged in with a valid tamu email
        Given I visit the practice page

    Scenario: Successfully generate and complete a practice test
        Given I select the topics "Velocity" and "Accuracy and precision of measurements, error propagation"
        And I select the question types "Definition" and "Free Response"
        And I enable Practice Test Mode
        And I submit the form
        Then I should be redirected to the practice test generation page
        Given I should see multiple randomly selected problems
        And I should see multiple input fields to submit my answers
        When I answer all the questions
        And I submit my practice exam
        Then I should see my score
        And I should receive feedback on my test answers

    Scenario: Attempt to generate a practice test without any topics or question types selected
        Given I don't select any topics
        And I don't select any question types   
        And I enable Practice Test Mode
        When I submit the form 
        Then I should see the message "No questions available for the selected criteria."
        And I should be redirected to the practice test form page