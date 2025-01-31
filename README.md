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
to run the applicaiton locally


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

## Contact
Phone: (972) 536-3310
Email: leogonzalez@tamu.edu

