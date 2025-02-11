Feature: Admin promotion

    As an administrator,
    so that I can manage accounts with professor privileges,
    I want to be able to promote tame accounts to professor status

    Scenario: Admin views list of accounts
        Given I am logged in as an administrator
        And I click "View Accounts"
        Then I should be on the accounts page
        And I should see a list of all accounts and their roles

    Scenario: Admin promotes an account to professor
        Given I am on the view accounts page
        And I click on a student account
        And I click "Make Professor"
        Then the selected account will have the professor role