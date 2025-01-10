# Sprint 1 Plan

## **Team Roles**
- **Sam Lightfoot** – Sprint 1 Product Owner  
- **Ethan Nguyen** – Sprint 1 Scrum Master  
- **Developers:**  
  - Casey Kung  
  - Olivia Lee  
  - Leo Gonzalez  
  - Owen Schultz  

---

## **Sprint Goal**
**The goal of this sprint is to give all users the ability to securely login, navigate through pages, and preview the practice questions.**

---

## **Sprint Backlog - User Stories**

### **User Stories**
1. As an instructor,  
   *So that I can access the instructor homepage,*  
   I want to log in using my `@tamu` Google account.

2. As a student,  
   *So that I can access the student homepage,*  
   I want to log in using my `@tamu` Google account.

3. As a user, 
   *So that I can finish using the platform,*  
   I want to log out of my account.

4. As a student,  
   *So that I can practice problems relevant to the selected concept,*  
   I want to be shown a randomly generated example problem after selecting a category.

5. As a student,  
   *So that I can focus in different areas of a unit,*  
   I want to choose the type(s) of questions I get (definition, multiple choice, free response).

6. As a student,
   *So that I can study for a cumulative exam,*  
   I want to select multiple categories to practice at once.

7. As a student,  
   *So that I protect information about my practice problems from my instructor,*  
   I want to be able to choose whether to opt into identifying my instructor.

8. As a student,  
   *So that I can practice problems relevant to a specific topic,*  
   I want to choose a specific category or topic from ENGR 216.

9. As a student,  
   *So that I can test my understanding,*  
   I want to submit my attempt at solving a problem as a computed numeric value.

---

## **Initial Developer Stories**

### **Owen**
- **User Story:**  
  *As a student, so that I can access the student homepage, I want to log in using my `@tamu` Google account.*  
  **Story Points:** 2  

  **Acceptance Criteria:** The student should be able to login with Google OAuth and be directed to the results page from which they can navigate to different parts of the application.

---

### **Leo**
- **User Story:**  
  *As a student, so that I can practice problems relevant to the selected concept, I want to be shown a randomly generated example problem after selecting a category.*  
  **Story Points:** 3

  **Acceptance Criteria:** The student should receive a randomly generated problem that corresponds with whatever category and question type they want to practice with the numbers in the problem randomized so they don’t repeat the same questions.

    ```Gherkin
Scenario: Unique questions within a set of problems.
Given I am logged in as a student
And I am on question page
When I answer a question
And I click submit
Then I see a new question
And it is not one I was given before
```

---

### **Casey**
1. **User Story:**  
   *As a student, so that I protect information about my practice problems from my instructor, I want to be able to choose whether to opt into identifying my instructor.*  
   **Story Points:** 1

   **Acceptance Criteria:** The student can select their instructor’s name from a dropdown of all ENGR 216 instructors, which can then be submitted. This opts them in to show their practice problem information with their instructor.

---   

### **Olivia**
1. **User Story:**  
   *As a student
    So that I can practice problems relevant to a specific topic,
    I want to choose a specific category or topic from ENGR 216*  
   **Story Points:** 1 

   **Acceptance Criteria:** The student should be able to see a checklist of topics/categories from which they can select what topics they want to get questions on in order to personalize their practice session. 

---

## **Important Links**
- **GitHub Repo:** [ENGR 216 Practice Problem Generator](https://github.com/tamu-edu-students/engr-216-practice-problem-generator)  
- **GitHub Project Board:** [Sprint 1 Project Board](https://github.com/orgs/tamu-edu-students/projects/85)  
- **Slack Channel:** [Join Slack Channel](https://join.slack.com/t/we-love-ritchey/shared_invite/zt-2xn35lgi8-z~u08Rk7ZyX4nZJxyMruwA)  
