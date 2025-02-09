Feature: Admin Login

    As an Admin,
    So that I can log into the admin home page
    I want to be able to sign in with my TAMU google account

    Scenario: Login with @tamu Google account
        Given I am on the homepage
        And I click "Login"
        And I choose a @tamu Google account
        Then I will be on the Admin Homepage

    Scenario: Login with non @tamu Google account
        Given I am on the homepage
        And I click "Login"
        And I do not choose a @tamu Google account
        Then I should be on the homepage
        And I should see "Please login with a @tamu email"