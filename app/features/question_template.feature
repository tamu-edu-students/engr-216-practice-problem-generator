Feature: Question Templates

    As a teacher,
    I want to be able to add a new practice question template,
    So that I can continuously update the questions that are given to students as the curriculum changes.

    Background:
        Given I am logged in as an instructor

    Scenario: Teacher wants to add a new practice question template
        When the Teacher clicks the add a new practice question button
        Then they are prompted to enter the template and submit