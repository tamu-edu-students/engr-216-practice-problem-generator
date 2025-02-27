Feature: Definition Questions

  Background:
    Given I am logged in as a student

  Scenario: Selecting the term based on its definition
    When I am on the question page
    And I have a definition question
    Then I should be able to select a term to match a definition