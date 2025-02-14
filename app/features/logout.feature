Feature: Logout

    As a user,
    so that I can finish using the platform,
    I want to log out of my account.


    Scenario: Logout from student homepage
        Given I am logged in as a student
        And I am on the student homepage
        When I click "Logout"
        Then I will be on the welcome page
        And I should see the message "You are logged out."

    Scenario: Logout from student homepage
        Given I am logged in as an instructor
        And I am on the instructor homepage
        When I click "Logout"
        Then I will be on the welcome page
        And I should see the message "You are logged out."