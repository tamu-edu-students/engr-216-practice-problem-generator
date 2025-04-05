Feature: Instructor View of Student Strengths and Weaknesses

  As an instructor
  I want to view the strengths and weaknesses of my students by topic
  So that I can provide targeted feedback and support their learning,
  And ensure that all performance metrics are displayed with consistent rounding

  Background:
    Given I am logged in as an instructor
    And I have student submissions recorded for various topics

  Scenario: View strengths and weaknesses for each student
    When I navigate to the "Student Details" page
    Then I should see "Student Details" as the page header
    And I should see a list of students
    And for each student, I should see their performance broken down by topic
    And performance metrics should be displayed with values rounded to two decimal places
    And topics with accuracy greater than or equal to 85% should be highlighted as strengths
    And topics with accuracy less than or equal to 60% should be highlighted as weaknesses