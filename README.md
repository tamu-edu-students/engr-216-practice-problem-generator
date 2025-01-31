# engr-216-practice-problem-generator

## Getting started

Make sure you have Ruby and Rails installed:
- Rails version 8.0.1
- Ruby version 3.3.4

### Clone repo
Clone using SSH or HTTPS

Change into the app directory once in the cloned repository directory
```bash
cd app
```

### Dependencies
```bash
bundle install
```
### Secrets
In order to access our OAuth client you need to add the key into your environment.
Run the following command
```bash
EDITOR=nano rails credentials:edit
```
This will create the file config/master.key
Replace the contents of this file with
```bash
22b3ea1218b4e8b9d28f3d6a41262935
```

## Database Setup
```bash
rails db:migrate
rails db:seed
```
Finally run 
```bash
rails server
```
to run the application locally


## Testing
Cucumber Tests
```bash
bundle exec cucumber
```

RSpec Tests
```bash
bundle exec rspec
```

## Deployment
Login into Heroku CLI with your account
```bash
heroku login
```
Create the application on your Heroku account
```bash
heroku apps:create
```
Make Master Key Available on Heroku
```bash
heroku config:set RAILS_MASTER_KEY=`cat config/master.key`
```
Provision a Database
```bash
heroku addons:create heroku-postgresql:essential-0
```
Push to heroku
```bash
git push heroku main
```
Migrate the Database
```bash
heroku run bundle exec rails db:migrate
```
Seed the Database
```bash
heroku run bundle exec rails db:seed
```
Launch the app in production
```bash
heroku open
```


## Contact
Phone: (972) 536-3310
Email: leogonzalez@tamu.edu

