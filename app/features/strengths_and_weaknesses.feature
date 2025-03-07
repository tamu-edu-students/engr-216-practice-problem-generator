Feature: Report Card Highlights Strengths and Weaknesses

  Scenario: Display strengths and weaknesses on the Progress page
    Given I am logged in
    And the following submissions exist:
            | Topic    | Question       | Correct? |
            | Velocity  | What is gravity? | false  |
            | Velocity  | What is gravity? | false  |
            | Velocity  | What is gravity? | false  |
            | Velocity  | What is gravity? | true  |
            | Acceleration  | What is gravity? | true |
            | Acceleration     | What is the formula for acceleration | true  |
            | Acceleration     | What is the formula for acceleration | true  |
            | Acceleration     | What is the formula for acceleration | true  |
    When I am on the "Progress" page
    Then my strongest topics with an accuracy of 85 or higher should be highlighted as strengths
    And my weakest topics with an accuracy of 60 or lower should be highlighted as weaknesses

  Scenario: No topics above 80% accuracy
    Given I am logged in
    And the following submissions exist:
            | Topic    | Question       | Correct? |
            | Velocity  | What is gravity? | false  |
            | Velocity  | What is gravity? | false  |
            | Velocity  | What is gravity? | false  |
            | Velocity  | What is gravity? | true  |
            | Acceleration  | What is gravity? | false |
            | Acceleration     | What is the formula for acceleration | false  |
            | Acceleration     | What is the formula for acceleration | true  |
            | Acceleration     | What is the formula for acceleration | true  |
    When I am on the "Progress" page
    Then I will not have topics highlighted as strengths

  Scenario: No topics below 60% accuracy
   Given I am logged in
   And the following submissions exist:
            | Topic    | Question       | Correct? |
            | Velocity  | What is gravity? | true  |
            | Velocity  | What is gravity? | true  |
            | Velocity  | What is gravity? | true  |
            | Velocity  | What is gravity? | true  |
            | Acceleration  | What is gravity? | true |
            | Acceleration     | What is the formula for acceleration | true  |
            | Acceleration     | What is the formula for acceleration | true  |
            | Acceleration     | What is the formula for acceleration | true  |
    When I am on the "Progress" page
    Then I will not have topics highlighted as weaknesses