Feature: Login as Admin

    As an admin,
    so that I can access the admin homepage,
    I want to log in using my @Tamu Google account.

    Scenario: Login as admin with valid tamu email
        Given I am on the welcome page
        And I have an admin account
        And I click "Login with Google"
        Then I will be on the Admin Homepage

    Scenario: Login as admin with invalid credentials
        Given I am on the welcome page
        When I have an invalid admin account
        And I click "Login with Google"
        Then I should be on the welcome page
