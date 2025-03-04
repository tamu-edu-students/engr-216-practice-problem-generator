Feature: Student Leaderboard

Scenario: Students view the leaderboard and correct rank
  Given "student1" has completed 10 problems with 8 correct answers
  Given "student2" has completed 15 problems with 12 correct answers
  Given "student3" has completed 7 problems with 5 correct answers
  Given I am logged in with a valid tamu email
  Given a predefined question exists
  And I visit the practice problems page
  And I select topic "Velocity"
  And I select question type "Free Response"
  And I press "Submit"
  And I input the correct solution
  When I click "Submit"
  When I visit the leaderboard page
  Then the system displays "student2" then "student1" then "student3" on the leaderboard
  Then the system informs the student "Your current rank is 4"

Scenario: Student with no practice sees leaderboard info prompting to practice
  Given I am logged in with a valid tamu email
  When I visit the leaderboard page
  Then the system informs the student "You are not currently on the leaderboard. Practice some problems to join the leaderboard."

Scenario: Non-student user does not see a rank display
  Given I have an instructor account
  When I visit the leaderboard page
  Then the system does not have any message about rank or system