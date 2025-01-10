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
**Students can login and view a question. Instructors can login and view a summary of student information.**

---

## **Sprint Backlog - User Stories**

### **User Stories**
1. Instructor Login - 1 Point

    As an instructor,  
   So that I can access the instructor homepage,  
   I want to log in using my `@tamu` Google account.

2. Student Login - 2 Points

    As a student,  
   *So that I can access the student homepage,*  
   I want to log in using my `@tamu` Google account.

3. Logout - 1 Point

    As a user, 
   *So that I can finish using the platform,*  
   I want to log out of my account.

4. Generate Random Problems - 3 Points

    As a student,  
   *So that I can practice problems relevant to the selected concept,*  
   I want to be shown a randomly generated example problem after selecting a category.

5. Select Problem Type - 1 Point

    As a student,  
   *So that I can focus in different areas of a unit,*  
   I want to choose the type(s) of questions I get (definition, multiple choice, free response).

6. Select Multiple Categories - 0 Points

    As a student,
   *So that I can study for a cumulative exam,*  
   I want to select multiple categories to practice at once.

7. Select Instructor - 1 Point

    As a student,  
   *So that I protect information about my practice problems from my instructor,*  
   I want to be able to choose whether to opt into identifying my instructor.

8. Select Problem Category - 1 Point

    As a student,  
   *So that I can practice problems relevant to a specific topic,*  
   I want to choose a specific category or topic from ENGR 216.

9. Submit Solution Attempt - 1 Point

    As a student,  
   *So that I can test my understanding,*  
   I want to submit my attempt at solving a problem as a computed numeric value.

**Total: 11 Story Points**

---

## **Initial Developer Stories**

### **Owen**
- **User Story:**  
  *As a student, so that I can access the student homepage, I want to log in using my `@tamu` Google account.*  
  **Story Points:** 2  

  **Acceptance Criteria:** >90% test coverage and all tests passing, rubocop >5 offenses

    ```
    Scenario: Login with valid @tamu Google account
    Give I am on the homepage
    And I click "Login"
    And I choose a @tamu Google account
    Then I will be on the Student Homepage

    Scenario: Login with non @tamu Google account
    Given I am on the homepage
    And I click "Login"
    Then I should be on the homepage
    And I should see "Please login with a @tamu email"
    ```

---

### **Leo**
- **User Story:**  
  *As a student, so that I can practice problems relevant to the selected concept, I want to be shown a randomly generated example problem after selecting a category.*  
  **Story Points:** 3

  **Acceptance Criteria:** >90% test coverage and all tests passing, rubocop >5 offenses

  ```
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

   **Acceptance Criteria:** >90% test coverage and all tests passing, rubocop >5 offenses

   ```
    Scenario: A student selects their instructor

    Given I am logged in as a student
    And I am on the profile view
    When I click the dropdown menu of CSCE 216 instructors
    And I select my instructor
    And I click 'Submit'
    Then the selected instructor will be opted in to view my practice problem results

    Scenario: A student does not select an instructor

    Given I am logged in as a student
    And I am on the profile view
    When I do not select an instructor from the dropdown menu of CSCE 216 instructors
    And I do not click 'Submit'
    Then my instructor will not be opted in to view my practice problem results
   ```
   

---   

### **Olivia**
1. **User Story:**  
   *As a student
    So that I can practice problems relevant to a specific topic,
    I want to choose a specific category or topic from ENGR 216*  
   **Story Points:** 1 

   **Acceptance Criteria:** >90% test coverage and all tests passing, rubocop >5 offenses

    ```
    Scenario: A student selects categories 

    Given I am logged in as a student
    And I am on the select problems view
    When I select problem categories
    And I click 'Submit'
    Then I will see them appear in the selected categories section
    And The practice questions given will be apart of the categories

    Scenario: A student does not select categories

    Given I am logged in as a student
    And I am on the select problems view
    When I click 'Submit' without selecting a problem
    Then No categories are in the selected categories section
    And I am given questions from all categories
    ```

---

## **Important Links**
- **GitHub Repo:** [ENGR 216 Practice Problem Generator](https://github.com/tamu-edu-students/engr-216-practice-problem-generator)  
- **GitHub Project Board:** [Sprint 1 Project Board](https://github.com/orgs/tamu-edu-students/projects/85)  
- **Slack Channel:** [Join Slack Channel](https://join.slack.com/t/we-love-ritchey/shared_invite/zt-2xn35lgi8-z~u08Rk7ZyX4nZJxyMruwA)  
