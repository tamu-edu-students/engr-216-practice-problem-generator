# Sprint 4 Plan

## **Team Roles:**		
- **Product Owner:** Ethan Nguyen
- **Scrum Master:** Sam Lightfoot
- **Developers:** 
    - Olivia Lee
    - Casey Kung
    - Leo Gonzalez 
    - Owen Schultz

---

## **Sprint Goal**
**Add relevant homepage content, have randomly generated numbers for the questions, implement advanced equation logic for complex questions, and implement the multiple choice questions.**

---

## **SPRINT BACKLOG - USER STORIES**

As an Admin  
So that I can easily navigate through the app  
I want to have a navigation bar that routes to all relevant pages  
- **Points:** 1  
- **Assigned Developer:** Casey

As a user  
So that I get a personalized experience  
I want the homepage to have a dashboard with relevant information  
- **Points:** 2  
- **Assigned Developer:** Casey

As a student  
So that I will get a more fair evaluation,  
I want the problems to accept rounded answers.  
- **Points:** 2  
- **Assigned Developer:** Olivia

As a student  
So that I can practice the same question multiple times  
I want the questions to have randomly generated numbers  
- **Points:** 2  
- **Assigned Developer:** Olivia

As a user  
So that I can practice multiple choice questions  
I want to be select multiple choice question and solve multiple choice questions  
- **Points:** 3  
- **Assigned Developer:** Leo

As an instructor  
So that I can write questions with array operations, square root, exponentiation, etc.  
I want to have complex equations enabled  
- **Points:** 5  
- **Assigned Developer:** Owen

**Total Points:** 15

---

## **INITIAL DEVELOPER STORIES**

### **Leo**
*As a user  
So that I can practice multiple choice questions  
I want to be select multiple choice questions  
And solve multiple choice questions*

**Story points:** 3  
**Acceptance criteria:** Users should be able to select multiple choice questions when generating a practice test or practice problems. The multiple choice question should show the user a question followed with 4 answer choices. The user should be able to select one of the four answer choices and submit their answer. The correct answer choice should be shown to the user after they submit and graded accordingly.

**SimpleCov:** >90%  
**Quality:** <2 issues  
**Style:** <2 issues

**Scenarios:**

Scenario: Select Multiple Choice Question for Practice Problems
Given I am on the Practice Questions page
When the page loads
Then I should Multiple Choice as a question type

Scenario: Select Multiple Choice Question for Practice Test
Given I am on the Practice Test page
When the page loads
Then I should Multiple Choice as a question type

Scenario: Multiple Choice answer selection
Given I have selected multiple choice
And I am on the Question page
Then I should see four answer choices
And be able to select one

Scenario: Solution for multiple choice
Given I have selected multiple choice
And I am on the Question page
And I select an answer choice
And press submit
Then I should see the correct answer choice

**Tasks:**
- Add multiple choice as a question type  
- Add answer choices table to match the question for each multiple choice  
- Add a field for answer  
- Add multiple choice questions to the database  
- Add functionality to problem generation to select a multiple choice question  
- Display the answer choices and allow the user to select one and submit  
- Display the correct answer after submitting  

**Time Estimate:** 8 hours

---

### **Casey**

As an Admin
So that I can easily navigate through the app
I want to have a navigation bar that routes to all relevant pages

- **Story points:** 1  
- **Acceptance criteria:** Administrators should be able to view a navigation bar on all pages after logging in. This navigation bar should contain links to Home, Profile (including logout), and Practice, at minimum. Clicking any link should redirect the user to the corresponding page, and active pages should be highlighted in the bar.

**SimpleCov:** >90%  
**Quality:** <2 issues  
**Style:** <2 issues

**Scenarios:**

Scenario: Display navigation bar
Given I am on any page of the application
When the page loads
Then I should see a navigation bar at the top of the screen

Scenario: Navigation bar contains all relevant links
Given I am on any page of the application
When I view the navigation bar
Then I should see links to “Home”, “Profile”, and “Practice”

Scenario: Clicking on a navigation link routes to the correct page
Given I am on any page of the application
When I click on the “Home” link in the navigation bar
Then I should be redirected to the “Home” page

Scenario: Active page is highlighted in the navigation bar
Given I am on the “Home” page
When I view the navigation bar
Then the “Home” link should be visually highlighted

**Tasks:**  
- Write feature tests for 

**Time Estimate:** 6 hours 

---

### **Owen**
As an instructor  
So that I can write questions with array operations, square root, exponentiation, etc.  
I want to have complex equations enabled

- **Story Points:** 5  
- **Acceptance Criteria:**
  - The system must support advanced mathematical operations (e.g., square roots, exponents, array/list manipulations) in question templates.
  - Instructors can enter these complex equations in a user-friendly way, and the system should correctly parse and evaluate them for problem generation.
  - Error handling should guide the instructor if an invalid equation format is provided (e.g., syntax errors).

**SimpleCov:** >90%  
**Quality:** <2 issues  
**Style:** <2 issues  

**Scenarios:**

Scenario: Adding complex equations in a question
Given I am on the “Create Custom Template” page as an instructor
When I enter a question with an operation like “\sqrt{x}” or “x^2 + y”
And I click “Create Template”
Then I should see a success message that confirms the equation was recognized and saved

Scenario: Invalid complex equation
Given I am on the “Create Custom Template” page as an instructor
When I enter a malformed equation (e.g., missing parentheses or invalid symbols)
And I click “Create Template”
Then I should see an error message indicating the equation format is invalid

Scenario: Generating a problem with complex equations
Given I am on the “Practice Problems” page as a student
And there exists at least one question with complex equations (e.g., “\sqrt{x} + y”)
When I select that question to practice
Then I should see a correctly rendered question and be able to submit an answer

**Tasks:**
- Extend the equation parser or logic to handle advanced operations (square root, exponentiation, array operations, etc.)
- Validate complex equations for syntax or parsing errors.
- Update the instructor’s custom template form to accept and store advanced operations.
- Write feature tests for creating/editing complex equation templates.
- Ensure problem generation can utilize these complex equations when serving questions to students.

**Time Estimate:** 6 hours with all tasks and sub-issues included.

---

### **Olivia**

As a student
So that I will get a more fair evaluation,
I want the problems to accept rounded answers.

**Story points:** 2  
**Acceptance criteria:** This will allow students to input rounded answers that are ‘close enough’ to the true answer within reason so that they can get a more fair grading. The student should not be able to round too much to get away with not calculating the answer, ie submitting 10 when the answer is 12.345  

**SimpleCov:** > 90%  
**Quality:** <2 issues  
**Style:** <2 issues  

**Scenarios:**  

Feature: Rounded Answers
Scenario: Student enters a number with less significant digits than expected
Given that a user is logged in as a student
And they are on the practice problems page
And the correct answer is 1.2345
And they enter an 1.23
Then they should see that they got the correct answer, and the view the unrounded answer to learn about significant digits

**Tasks:**  
- Add a column to the questions table for explanations  
- Display the question explanations upon submission of a correct answer  
- Seed the database with more questions  

**Time Estimate:** 6 hours

---

## **IMPORTANT LINKS**
**GitHub Repo**  
<https://github.com/tamu-edu-students/engr-216-practice-problem-generator>  

**GitHub Project Board**  
<https://github.com/orgs/tamu-edu-students/projects/85>  

**Slack Channel**  
<https://join.slack.com/t/we-love-ritchey/shared_invite/zt-2xn35lgi8-z~u08Rk7ZyX4nZJxyMruwA>