Team Roles:		  
Product Owner: Olivia Lee  
Scrum Master: Casey Kung  
Developers: Leo Gonzalez, Owen Schultz, Sam Lightfoot, Ethan Nguyen

Sprint Goal: Ensure roles are properly validated for each page, condense student practice pages, and refine instructor view through more question template functionality and insights on student practice data.

### **SPRINT BACKLOG \- USER STORIES**

As an Instructor  
So that I can quickly understand how my class is doing  
I want to see accuracy among students and topics on the dashboard  
Points: 1  
Assigned Developer: Sam

As an instructor  
So that I can view specific information about my students  
I want to see the strengths and weaknesses information about each student  
Points: 2  
Assigned Developer: Sam

As an instructor  
So that I can modify existing practice questions  
I want to be able to view, edit, and delete question templates  
Points: 4  
Assigned Developer: Owen

As an admin  
So that I can accurately verify the functionalities of all roles  
I want to be able to have permissions to perform student and instructor actions  
Points: 1  
Assigned Developer: Leo

As an instructor  
So that I can easily input a new question  
I want the template form to explain and give examples on how to fill each row and remove redundant information  
Points: 2   
Assigned Developer: Leo

As a student  
So that I can easily access all types of practice in one place  
I want the practice test and practice problem pages to be merged into a single practice section  
Points: 3  
Assigned Developer: Ethan

Total Points: 13

**INITIAL DEVELOPER STORIES**  
**Leo**  
As an admin  
So that I can accurately verify the functionalities of all roles  
I want to be able to have permissions to perform student and instructor actions  
**Story points:** 1  
**Acceptance criteria:**   
**SimpleCov:** \>90%  
**Quality**: \<2 issues  
**Style**: \<2 issues  
**Scenarios:**

* Scenario: Admin created question template  
  * Given: I am an admin on the instructor view  
  * And I attempt to create a custom template  
  * Then I should see “question template added successfully  
* Scenario: Admin attempts a practice problem  
  * Given: I am an admin on the student view page  
  * And I attempt a practice problem  
  * Then I should be able to submit a problem and get feedback

**Tasks:**

- [ ] Merge the instructor and student view into the admin page  
- [ ] Allow for admin to also have student and instructor permissions  
- [ ] 

**Time Estimate:** 5 hours with all tasks completed and styling maintained

**Sam**  
As an instructor  
So that I can view specific information about my students  
I want to see the strengths and weaknesses information about each student  
**Story points:** 2  
**Acceptance criteria:** Instructor student summary page should be changed to student details, instructor should be able to see all of the existing data, as well as when clicking on a student see that students row in the table expand to show the strengths and weaknesses information  
**SimpleCov:** \>90%  
**Quality**: \<2 issues  
**Style**: \<2 issues  
**Scenarios:**

* Scenario: Instructor views strengths and weaknesses  
  * Given an instructor is on the student details page  
  * And they click on a cell with a student’s name  
  * Then they should see their strengths and weaknesses data

**Tasks:**

- [ ] Make the students names/ cell be clickable  
- [ ] Allow for the table to add a row/ examined that row downwards  
- [ ] Display the previously defined S\&W data in that extra space

**Time Estimate:** 3 hours with all tasks and sub issues included.

**Owen**  
As an instructor  
So that I can modify existing practice questions  
I want to be able to view, edit, and delete question templates  
**Story Points**: 4  
**Acceptance Criteria**

* Instructor should have a new page to manage question templates, all parts of question templates should be viewable and editable, question templates should be deletable as well

**SimpleCov**: \>90%  
**Quality**: \<2 issues  
**Style**: \<2 issues  
**Scenarios**

* New question templates manager page  
  * Given I am logged in as an instructor  
  * When I navigate to the question templates manager page  
  * Then I should see a list of all existing question templates displayed based on their topic and type  
  * And each template should have options to  “Edit” and “Delete”  
* Viewing/editing a question template  
  * Given I am on the question templates management page  
  * When I click on "Edit" for a specific question template  
  * Then I should be taken to an edit form pre-filled with that question's current details  
  * And I should be able to modify the topic, type, question text, variables, ranges, decimals, equation, or explanation  
  * And when I save the changes  
  * Then I should see a confirmation message  
  * And the changes should be reflected in the current question template  
* Deleting a question template  
  * Given I am on the question templates management page  
  * When I click on "Delete" for a specific question template  
  * Then I should be asked to confirm the deletion  
  * And upon confirmation, the question template should be removed from the list  
  * And I should see a success message confirming the deletion

**Tasks**

* Create a new Question Template Manager page accessible only to instructors  
* Display a list of all existing question templates grouped or labeled by topic and type  
* Implement "Edit" functionality:  
  * Pre-fill form fields with current question data (topic, type, question text, variables, variable ranges, variable decimals, equation, explanation)  
  * Allow updates to all editable fields  
  * Validate inputs and show appropriate error messages  
* Implement "Delete" functionality with confirmation modal or alert  
* Add backend routes, controller actions, and views for managing question templates  
* Write feature specs to test:  
  * Viewing the question template list  
  * Editing and saving changes  
  * Deleting a question template

**Time Estimate**: 6 hours with all tasks and sub-issues included.

**Ethan**  
As a student  
So that I can easily access all types of practice in one place  
I want the practice test and practice problem pages to be merged into a single practice section  
**Story points:** 3  
**Acceptance criteria:** Practice test page should be removed, practice problem and test functionality should be accessible from a single unified Practice page, unified Practice page should allow students to select topic(s) and type(s) for practice problems, select number of questions for practice tests  
**SimpleCov:** \> 90%  
**Quality**: \<2 issues  
**Style**: \<2 issues  
**Scenarios:** 

* Scenario: Navigating to the unified practice section  
  * Given I am logged in as a student  
  * When I click on "Practice" in the navigation bar  
  * Then I should see options for "Practice Problems" and "Practice Tests" on the same page  
* Scenario: Starting a practice problem from the unified section  
  * Given I am on the Practice page  
  * When I select a topic and type for a practice problem  
  * And I click "Start Practice Problem"  
  * Then I should be taken to a page with a randomly generated practice problem  
  * And I should see an input field to submit my answer  
* Scenario: Starting a practice test from the unified section  
  * Given I am on the Practice page  
  * When I select a topic and number of questions for a practice test  
  * And I click "Start Practice Test"  
  * Then I should be taken to the practice test interface  
  * And I should see a list of questions and fields to submit answers

**Tasks:** 

* Create a new unified "Practice" page accessible from the navigation bar  
* Design UI to include both "Practice Problems" and "Practice Tests" options on the same page  
* Update routes and controller logic to handle form submissions for both practice problems and practice tests from the new page  
* Refactor or merge existing views (practice\_problems, practice\_tests) into components/partials for reuse in the unified view  
* Preserve existing filtering (topics, types, number of questions)  
* Ensure navigation to practice problem generation and test interfaces still functions correctly  
* Update navigation bar to link to the new Practice page and remove separate links to old pages  
* Write feature specs for:  
  * Visiting the unified practice page  
  * Starting a practice problem  
  * Starting a practice test  
* Remove or deprecate old individual practice page views and routes

**Time Estimate:** 5 hours

IMPORTANT LINKS

1. **GitHub Repo**

[https://github.com/tamu-edu-students/engr-216-practice-problem-generator](https://github.com/tamu-edu-students/engr-216-practice-problem-generator)

2. **GitHub Project Board**

[https://github.com/orgs/tamu-edu-students/projects/85](https://github.com/orgs/tamu-edu-students/projects/85)

3. **Slack Channel**  
   [https://join.slack.com/t/we-love-ritchey/shared\_invite/zt-2xn35lgi8-z\~u08Rk7ZyX4nZJxyMruwA](https://join.slack.com/t/we-love-ritchey/shared_invite/zt-2xn35lgi8-z~u08Rk7ZyX4nZJxyMruwA)

