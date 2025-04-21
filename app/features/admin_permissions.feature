Feature: Admin Permissions

  As an administrator
  I want to have access only to admin-specific functionalities
  So that I can submit question templates while practice tests or generated problems remain unavailable,
  And non-admin users cannot access admin role pages.  

  Background:
    Given the following topics exist:
      | topic_id | topic_name         |
      | 1        | Motion             |
    And the following types exist:
      | type_id | type_name          |
      | 1       | Free response       |
      | 2       | Multiple Choice     |

  Scenario: Admin can submit a question template
    Given I am logged in as an admin
    When I navigate to the "Custom Template" page
    And I select "Equation-Based" as Question Type
    And I press "Continue"
    And I fill in valid equation data
    Then I should see "Equation-based question template created!"
    And a new question with kind "equation" should exist

  Scenario: Admin cannot submit practice tests or generated problems
    Given I am logged in as an admin
    When I navigate to the "Practice Tests" page
    Then I should be redirected to the "Home" page
    And I should see an error message "Admin not allowed to access practice test page"

  Scenario: Non-admin users cannot access the admin roles page
    Given I am logged in as a student
    When I navigate to the "Admin Roles" page
    Then I should be redirected to the "Home" page
    And I should see an error message "You do not have permission to access this page."