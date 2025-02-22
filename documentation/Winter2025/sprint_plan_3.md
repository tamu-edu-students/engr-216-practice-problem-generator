# Sprint 3 Plan

## **Team Roles**
- **Product Owner:** Leo Gonzalez  
- **Scrum Master:** Owen Schultz  
- **Developers:**  
  - Olivia Lee  
  - Casey Kung  
  - Sam Lightfoot  
  - Ethan Nguyen  

---

## **Sprint Goal**
**Students can track their strengths and weaknesses in their report card, receive answer explanations, and view a leaderboard ranking based on their correct answers. Instructors can view the overall progress of the students in the class, and all users can interact easily with styled user interfaces and navigate easily with a navigation bar.**

---

## **Sprint Backlog - User Stories**

### **User Stories**
As a student,  
So that I can focus on areas of improvement and recognize topics I excel in,  
I want my report card to highlight my strengths and weaknesses.  
- **Points:** 2  
- **Assigned Developer:** Casey  

As a student,  
So that I can understand why my answer is correct or incorrect,  
I want to receive an explanation detailing the correctness of my solution.  
- **Points:** 2  
- **Assigned Developer:** Olivia  

As a student,  
So that I can be motivated to learn through competition,  
I want to view a leaderboard that ranks students based on correct answers.  
- **Points:** 3  
- **Assigned Developer:** Olivia  

As a user,  
So that I can easily navigate through the app,  
I want to have a navigation bar that routes to all relevant pages.  
- **Points:** 2  
- **Assigned Developer:** Casey  

As an instructor,  
So that I can assess the overall performance of my class and identify common areas of difficulty,  
I want to see a summary report card of all students and a view of those who have identified me as their instructor.  
- **Points:** 3  
- **Assigned Developer:** Sam  

As a student,  
So that I can learn the definitions clearly,  
I want to be given a definition and be asked to submit the corresponding term.  
- **Points:** 1  
- **Assigned Developer:** Sam  

As a user,  
So that I can easily use the product,  
I want to see a user-friendly design that is easy to navigate.  
- **Points:** 4  
- **Assigned Developer:** Ethan  

**Total Points:** 18  

---

## **Initial Developer Stories**

### **Sam**
- **User Story:**  
  *As an instructor,  
  So that I can assess the overall performance of my class and identify common areas of difficulty,  
  I want to see a summary report card of all students and a view of those who have identified me as their instructor.*  

  **Story Points:** 3  
  **Acceptance Criteria:** An instructor will be able to view the performance summary of all students, toggle between all students and their own students, see the number of questions completed, correct/incorrect responses, and common difficulties.  
  **SimpleCov:** > 90%  
  **Quality:** < 2 issues  
  **Style:** < 2 issues  

  **Scenarios:**  
  ```
  Feature: Instructor Summary Report  
    Background:  
      Given I am logged in as an instructor  
    Scenario: View summary report card of all students  
      When I navigate to the instructor summary report page  
      Then I should see a summary report card of all students  
      And I should see the overall performance of the class  
      And I should see common areas of difficulty  
    Scenario: View students who have identified me as their instructor  
      When I navigate to the instructor summary report page  
      And I click on "Show My Students"  
      Then I should see a list of students who have identified me as their instructor  
      And I should see the performance of these students  
      And I should see common areas of difficulty for these students  
  ```

  **Tasks:** Create a new view on the instructor page, process and display data, include a toggle for selected students.  
  **Time Estimate:** 7 hours  

---

### **Olivia**
- **User Story:**  
  *As a student,  
  So that I can understand why my answer is correct or incorrect,  
  I want to receive an explanation detailing the correctness of my solution.*  

  **Story Points:** 2  
  **Acceptance Criteria:** Students should see explanations detailing why their answer is correct or incorrect, including mathematical walkthroughs and definition reasoning.  
  **SimpleCov:** > 90%  
  **Quality:** < 2 issues  
  **Style:** < 2 issues  

  **Scenarios:**  
  ```
  Feature: Explanation of Correctness  
    Scenario: Student wants to see why they got an answer wrong  
      Given that a user is logged in as a student  
      And they are on the practice problems page  
      And they enter an incorrect answer  
      Then they should see an explanation of why that answer is wrong and how to get the correct answer  
  ```

  **Tasks:** Add a column for explanations in the database, display explanations upon submission, seed database with question explanations.  
  **Time Estimate:** 6 hours  

---

### **Casey**
- **User Story:**  
  *As a user,  
  So that I can easily navigate through the app,  
  I want to have a navigation bar that routes to all relevant pages.*  

  **Story Points:** 2  
  **Acceptance Criteria:** Users should see a navigation bar on all pages post-login, containing links to "Home," "Profile," and "Practice." Active pages should be highlighted.  
  **SimpleCov:** > 90%  
  **Quality:** < 2 issues  
  **Style:** < 2 issues  

  **Tasks:** Implement the navigation bar with appropriate links, ensure responsiveness, create CSS styles for highlighting active pages, test routing.  
  **Time Estimate:** 6 hours  

---

### **Ethan**
- **User Story:**  
  *As a user,  
  So that I can easily use the product,  
  I want to see a user-friendly design that is easy to navigate.*  

  **Story Points:** 4  
  **Acceptance Criteria:** UI should be clean, modern, and responsive. Navigation, buttons, and interactive elements should be well-styled and accessible.  
  **SimpleCov:** > 90%  
  **Quality:** < 2 issues  
  **Style:** < 2 issues  

  **Tasks:** Apply consistent design across the app, improve button styling, implement responsive design, conduct final testing.  
  **Time Estimate:** 12 hours  

---

## **Important Links**
- **GitHub Repo:** [ENGR 216 Practice Problem Generator](https://github.com/tamu-edu-students/engr-216-practice-problem-generator)  
- **GitHub Project Board:** [Sprint 3 Project Board](https://github.com/orgs/tamu-edu-students/projects/85)  
- **Slack Channel:** [Join Slack Channel](https://join.slack.com/t/we-love-ritchey/shared_invite/zt-2xn35lgi8-z~u08Rk7ZyX4nZJxyMruwA)  
