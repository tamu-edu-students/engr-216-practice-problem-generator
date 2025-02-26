Feature: Student Leaderboard

Scenario: Students view the leaderboard
  Given students "student1", "student2", and "student3" exist in the system
  And "student1" has completed 10 problems with 8 correct answers
  And "student2" has completed 15 problems with 12 correct answers
  And "student3" has completed 7 problems with 5 correct answers
  When a student views the leaderboard
  Then the system displays "student2" then "student1" then "student3" on the leaderboard

Scenario: Students completes more correct problems
  Given students "student1" and "student2" initially solve 0 problems
  When "student1" solves 3 problems with 3 correct answers
  And "student2" solves 5 problems with 4 correct answers
  Then the leaderboard updates its display to match the changes
  And the system notifies both students about their rank changes