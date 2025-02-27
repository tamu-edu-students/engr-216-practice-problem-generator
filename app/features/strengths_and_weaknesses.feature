Feature: Report Card Highlights Strengths and Weaknesses

  Background:
    Given I am logged in as a student

  Scenario: Display strengths and weaknesses on the report card
    Given I have received my report card
    When I view my grades
    Then my strongest subjects should be highlighted as strengths
    And my weakest subjects should be highlighted as areas for improvement

  Scenario: Identify strengths based on high scores
    Given I have scores above 85% in some subjects
    When I view my report card
    Then those subjects should be labeled as strengths

  Scenario: Identify weaknesses based on low scores
    Given I have scores below 60% in some subjects
    When I view my report card
    Then those subjects should be labeled as areas for improvement

  Scenario: Show performance trends
    Given I have received multiple report cards over time
    When I view my latest report card
    Then I should see trends indicating if my performance in a subject has improved or declined