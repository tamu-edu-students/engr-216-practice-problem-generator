Feature: Login as Instructor

    As an instructor,
    so that I can access the instructor homepage,
    I want to log in using my @Tamu Google account.

    Scenario: Login as instructor with valid tamu email
        Given I am on the welcome page
        And I have an instructor account
        And I click "Sign in with Google"
        Then I will be on the Instructor Homepage

    Scenario: Login as instructor with invalid credentials
        Given I am on the welcome page
        When I have an invalid instructor account
        And I click "Sign in with Google"
        Then I should be on the welcome page
        And I should see the message "Please login with an @tamu email"

    Scenario: Student tries to access Instructor Homepage
        Given I am on the welcome page
        And I have a valid student account
        And I click "Sign in with Google"
        When I visit the Instructor Homepage