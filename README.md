Breezevote
==========

This Rails application is a website that manages the paperwork for absentee voting (and eventually all voting) for people who'd rather deal with that stuff on their computer or phone.

#### Todos ####

- email user
  - on sign up
  - with completed form
- improve backbone form
  - add more helper text
  - use gon for user part
- data
  - add election model
  - add political parties to users and documents
  * delete records on user destroy
  * write request tests for users
  * restrict access
  - move concerns to inheritance
  - set up DelayedJob to handle PDF creation
- government forms
  - handle political parties
  - handle elections
  * handle addresses abroad
  - add mailing address to second page
- layout
  - create user page
  - put sign up/sign in in sidebar
  - create logo
  * create /vision page
  - add flash messages to layout <%= notice %> <%= alert %>
- deploy
  * set up heroku
  * set up s3 with restricted access
  - set up Mandrill
  - set up with domain name
  - set up breezevote email

#### Running tests ####

```sh
$ bundle exec rspec spec
```