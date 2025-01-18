Feature: Login as Student

    As a student,
    so that I can access the student homepage,
    I want to log in using my @Tamu Google account.

    Scenario: Login with valid @tamu Google account
        Given I am on the login page
        When I click "Login"
        And I choose a valid @tamu Google account
        Then I will be on the Student homepage

    Scenario: Login with invalid credentials
        Given I am on the login page
        When I click "Login"
        And I enter invalid credentials
        Then I should be on the login page
        And I should see "Please login with valid credentials"

    Scenario: Login with non @tamu Google account
        Given I am on the login page
        When I click "Login"
        And I enter a non-tamu Google account
        Then I should be on the login page
        And I should see "Please login with a @tamu email"