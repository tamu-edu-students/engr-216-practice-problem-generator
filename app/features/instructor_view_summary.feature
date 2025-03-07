Feature: Instructor Summary Report

  Background:
    Given I am logged in as an a instructor

  Scenario: View summary report card of all students
    When I navigate to the instructor summary report page
    Then I should see a summary report card of all students
    And I should see the overall performance of the class
    And I should see common areas of difficulty

  Scenario: View students who have identified me as their instructor
    When I navigate to the instructor summary report page
    And I choose to click on "Show My Students"
    Then I should see a list of students who have identified me as their instructor
    And I should see the performance of these students
    And I should see common areas of difficulty for these students