Feature: Instructor Summary Report
  As an instructor
  I want to view summary data about my students and common trouble areas
  So that I can focus my teaching efforts

  Background:
    Given I am logged in as a person instructor

  Scenario: View summary report of all students
    When I navigate to the instructor summary report page
    Then I should see star "All Students"
    And I should see star "Student Progress Summary"
    And I should see star "Topic with the Most Missed Questions"