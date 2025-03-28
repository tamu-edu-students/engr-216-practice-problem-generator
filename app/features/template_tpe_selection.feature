Feature: Instructor selects a question template type

  Background:
    Given I am logged in as an instructor

  Scenario: Instructor selects equation template
    When I visit the template selector page
    And I select "Equation" from the question type dropdown
    And I press "Continue"
    Then I should be on the equation template form

  Scenario: Instructor selects dataset template
    When I visit the template selector page
    And I select "Dataset" from the question type dropdown
    And I press "Continue"
    Then I should be on the dataset template form

  Scenario: Instructor selects definition template
    When I visit the template selector page
    And I select "Definition" from the question type dropdown
    And I press "Continue"
    Then I should be on the definition template form