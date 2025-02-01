# Sprint 2 Plan

## **Team Roles**
- **Casey Kung** – Sprint 1 Product Owner  
- **Olivia Lee** – Sprint 1 Scrum Master  
- **Developers:**  
  - Sam Lightfoot  
  - Ethan Nguyen  
  - Leo Gonzalez  
  - Owen Schultz  

---

## **Sprint Goal**
**Student can take practice tests and view their progress, instructors can add question templates, and administrators can view and change role of all accounts.**

---

## **Sprint Backlog - User Stories**

### **User Stories**
So that I can take a ENGR 216 practice test
I want to access a system that allows me to attempt and submit a practice test with feedback
- Points: 3
- Assigned Developer: Ethan

As a student
so that I can see what area I need to work on
I want to be able to view the questions I got right and wrong
- Points: 3
- Assigned Developer: Leo

As an administrator,
so that I can manage accounts with professor privileges,
I want to be able to promote tame accounts to professor status
- Points: 3
- Assigned Developer: Owen

As an Admin,
So that I can log into the admin home page
I want to be able to sign in with my TAMU google account
- Points: 1
- Assigned Developer: Owen

As an instructor,
So that I can create new questions for my students
I want to add a new question template to the app
- Points: 4
- Assigned Developer: Sam

**Total: 14 Story Points**

---

## **Initial Developer Stories**

### **Sam**
- **User Story:**  
  *As an instructor,
So that I can create new questions for my students
I want to add a new question template to the app*  

  **Story Points:** 4

  **Acceptance Criteria:** An instructor should be able to create a new template, which will include being able to add an image like a free body diagram, add a formula that will base the variables and answer off of, and set a range of different imputed values (ie 0<mass<100). This template will be added to a unit, and the students will then see this question if that unit is selected.

  **SimpleCov:** > 90%

  **Quality:** < 2 issues
  
  **Style:** < 2 issues
    ```
    Feature: Question Templates
      Scenario: Teacher wants to add a new practice question template
        When the Teacher clicks the add a new practice question button
        Then they are prompted to enter the template and submit
    ```
  **Tasks:** This will include creating a new view on the instructor page, and a default template for creating a new question. These inputted values will need to be put into the database for all users to see. The instructor will also need to be able to view and edit existing templates.
  
  **Time Estimate:** 9 hours with all tasks and sub issues included

---

### **Leo**
- **User Story:**  
  *As a student
so that I can see what area I need to work on
I want to be able to view the questions I got right and wrong*  

  **Story Points:** 3

  **Acceptance Criteria:** This will also create a new view, but on the student page. This will allow students to view their progress as they answer questions. They will be able to view which topics they are doing best on and their score for each topic.

  **SimpleCov:** > 90%

  **Quality:** < 2 issues
  
  **Style:** < 2 issues
  ```
  Feature: Student view personal progress
    Scenario: Student wants to view question progress
      When the Student navigates to progress page
      Then they should see their progress for each topic type
  ```
  **Tasks:** First need to make sure question submissions are being tied to the account in the database. Once in the progress view, will need to pull all questions the student has answered and mark questions they mark correctly. Sort all questions based on topic and see what percentage they answered correctly and display this for the user as a graph.
  
  **Time Estimate:** 8 hours

---

### **Owen**
1. **User Story:**  
   *As an administrator,
so that I can manage accounts with professor privileges,
I want to be able to promote tamu accounts to professor status*  

   **Story Points:** 3

   **Acceptance Criteria:** Administrator should be able to log in with Google OAuth and be navigated to the home page, from there they can view a list of all accounts and their role. The admin should then be able to change the role of any account to either student, professor, or administrator.

   **SimpleCov:** > 90%

  **Quality:** < 2 issues
  
  **Style:** < 2 issues
   ```
    Feature: Admin promotion
      Scenario: Admin views list of accounts
        Given I am logged in as an administrator
        And I click "View Accounts"
        Then I should be on the accounts page
        And I should see a list of all accounts and their roles
      Scenario: Admin promotes an account to professor
        Given I am on the view accounts page
        And I click on a student account
        And I click "Make Professor"
        Then the selected account will have the professor role
   ```
   **Tasks:** This story will involve the creation of the admin role, adding to our database, and replicating the instructor view. We will also need a page that displays all user accounts, and their roles. Alongside each account, should have a dropdown to change the role of that account.
  
  **Time Estimate:** 7 hours with all tasks and sub issues included.

---   

### **Ethan**
1. **User Story:**  
   *As a user
So that I can take a ENGR 216 practice test
I want to access a system that allows me to attempt and submit a practice test with feedback*  

   **Story Points:** 3

   **Acceptance Criteria:** Administrator should be able to log in with Google OAuth and be navigated to the home page, from there they can view a list of all accounts and their role. The admin should then be able to change the role of any account to either student, professor, or administrator.
   
    **SimpleCov:** > 90%
  
    **Quality:** < 2 issues
    
    **Style:** < 2 issues
    ```
    Feature: Practice Test Functionality
      Scenario: Access a practice test 
        Given I am a user
        And I am logged in
        When I go to the "Practice Tests" section
        Then I should see a list of available practice tests
        And I should be able to select a ENGR 216 practice test
      Scenario: Attempt and submit a practice test
        Given I am logged in
        And I have selected a ENGR 216 practice test
        When I start the test
        And I answer all the questions
        And I submit my answers
        Then I should get a message saying "Test submitted"
        And I should receive feedback on my test answers
    ```
    **Tasks:** This story will be implementing the functionality to allow users to access the "Practice Tests" section, developing a feature to list all available practice tests, including ENGR 216, for the user to select, and then implementing a feedback system that provides users with responses to their submitted test answers.
  
    **Time Estimate:** 8 hours
---

## **Important Links**
- **GitHub Repo:** [ENGR 216 Practice Problem Generator](https://github.com/tamu-edu-students/engr-216-practice-problem-generator)  
- **GitHub Project Board:** [Sprint 1 Project Board](https://github.com/orgs/tamu-edu-students/projects/85)  
- **Slack Channel:** [Join Slack Channel](https://join.slack.com/t/we-love-ritchey/shared_invite/zt-2xn35lgi8-z~u08Rk7ZyX4nZJxyMruwA)  
