Feature: Practice Test Functionality

    As a user
    So that I can take a ENGR 216 practice test
    I want to access a system that allows me to attempt and submit a practice test with feedback

    Background: 
        Given a predefined question exists
        Given another predefined question exists
        Given a predefined dataset question exists
        Given I am logged in with a valid tamu email
        Given I visit the practice tests page

    Scenario: Successfully generate and complete a practice test
        Given I select the topics "Velocity" and "Accuracy and precision of measurements, error propagation"
        And I select the question types "Definition" and "Free Response"
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
        When I submit the form 
        Then I should see the message "No questions available for the selected criteria."
        And I should be redirected to the practice test form page

    Scenario: Generating a dataset question
        Given I select the topics "Statistics" and "Accuracy and precision of measurements, error propagation"
        And I select the question types "Definition" and "Free Response"
        And I submit the form
        Then I should be redirected to the practice test generation page
        And I should see a list of numbers representing the dataset

    Scenario: Generating a definition problem
        Given a predefined definition question exists
        And I select topic "Velocity"
        And I select question type "Free Response"
        And I submit the form
        Then I should be redirected to the practice test generation page
        And I should see the definition question

    Scenario: Generating a multiple choice problem
        Given a predefined multiple choice question exists
        And I have selected Multiple choice and General Knowledge
        And I submit the form
        Then I should be redirected to the practice test generation page
        Then I should see three answer choices
        And I should be able to select one

    Scenario: Generating median problem
        Given a predefined median question exists
        And I select topic "Statistics"
        And I select question type "Free Response"
        And I submit the form
        Then I should be redirected to the practice test generation page
        And I should see a list of numbers representing the dataset

    Scenario: Generating mode problem
        Given a predefined mode question exists
        And I select topic "Statistics"
        And I select question type "Free Response"
        And I submit the form
        Then I should be redirected to the practice test generation page
        And I should see a list of numbers representing the dataset

    Scenario: Generating range problem
        Given a predefined range question exists
        And I select topic "Statistics"
        And I select question type "Free Response"
        And I submit the form
        Then I should be redirected to the practice test generation page
        And I should see a list of numbers representing the dataset

    Scenario: Generating standard deviation problem
        Given a predefined standard deviation question exists
        And I select topic "Statistics"
        And I select question type "Free Response"
        And I submit the form
        Then I should be redirected to the practice test generation page
        And I should see a list of numbers representing the dataset

  Scenario: Generating variance problem
        Given a predefined variance question exists
        And I select topic "Statistics"
        And I select question type "Free Response"
        And I submit the form
        Then I should be redirected to the practice test generation page
        And I should see a list of numbers representing the dataset