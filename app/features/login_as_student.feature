Feature: Login as Student

    As a student,
    so that I can access the student homepage,
    I want to log in using my @Tamu Google account.

    Scenario: Login with valid @tamu Google account
        Given I am on the welcome page
        When I have a valid @tamu Google account 
        And I click "Login with Google"
        Then I will be on the Student homepage

    Scenario: Login with non @tamu Google account
        Given I am on the welcome page
        When I have a non-tamu Google account
        And I click "Login with Google" 
        Then I should be on the welcome page
        And I should see a message "Please login with an @tamu email"

    Scenario: Try to access the student homepage while not being logged in
        Given I am not logged in
        When I try to go to the student homepage
        Then I should be on the welcome page
        And I should see a message "You must be logged in to access this section."