Feature: Select Instructor
    
    As a student,
    so that I protect information about my practice problems from my instructor,
    I want to be able to choose whether to opt into identifying my instructor.

    Scenario: A student selects their instructor
        Given I am logged in as a student
        And I am on the profile view
        When I click the dropdown menu of CSCE 216 instructors
        And I select my instructor
        And I click the 'Save Instructor' button
        Then the selected instructor will be opted in to view my practice problem results

    Scenario: A student does not select an instructor
        Given I am logged in as a student
        And I am on the profile view
        When I do not select an instructor from the dropdown menu of CSCE 216 instructors
        And I do not click 'Submit'
        Then my instructor will not be opted in to view my practice problem results