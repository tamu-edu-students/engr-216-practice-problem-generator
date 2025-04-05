Feature: Instructor Dashboard

  As an instructor
  I want to view a comprehensive summary of student statistics
  So that I can assess overall class performance and identify areas for improvement

  Background:
    Given I am logged in as an instructor

  Scenario: View comprehensive instructor dashboard
    When I navigate to the instructor summary report page
    Then I should see "Student Statistics" as the dashboard header
    And I should see a summary report card of all students
    And I should see overall performance metrics for each student
    And I should see a breakdown of performance by topic
    And I should see the most missed topic highlighted