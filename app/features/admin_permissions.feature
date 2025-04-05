Feature: Admin Permissions

  As an administrator
  I want to have access only to admin-specific functionalities
  So that I can submit question templates while practice tests or generated problems remain unavailable,
  And non-admin users cannot access admin role pages.

  Background:
    Given I am logged in as an admin

  Scenario: Admin can submit a question template
    When I navigate to the "Custom Template" page
    And I fill in valid template data
    And I submit the question template form
    Then I should see a confirmation message "Question template created!"

  Scenario: Admin cannot submit practice tests or generated problems
    When I navigate to the "Practice Tests" page
    Then I should see an error message "Access forbidden"
    And I should not be able to submit a practice test

  Scenario: Non-admin users cannot access the admin roles page
    Given I am logged in as a student
    When I navigate to the "Admin Roles" page
    Then I should be redirected to the welcome page
    And I should see an alert message "You are not authorized to access this page."