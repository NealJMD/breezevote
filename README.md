Breezevote
==========

This Rails application is a website that manages the paperwork for absentee voting (and eventually all voting) for people who'd rather deal with that stuff on their computer or phone.

#### Todos ####

- email user
  - on sign up
  - with completed form
- improve backbone form
  * add helper text
  * put validation messages somewhere better
  * validate on field blur and page turn
- data
  - add election model
  * add political parties to users and documents
  * add delivery status selection
  * restrict access
  - move concerns to inheritance
- government forms
  - handle political parties
  - handle elections
  * handle addresses abroad
  - add mailing address to second page
- layout
  - create user page
  - create document show page
  * create devise views
  * create baseline layout
  * create logo
  * create explanatory homepage
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