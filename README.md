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

### Dependencies and Database Setup
```bash
bundle install
rails db:migrate
rails db:seed
```

## Testing
Cucumber Tests
```bash
bundle exec cucumber
```

RSpec Tests
```bash
bundle exec rspec
```
