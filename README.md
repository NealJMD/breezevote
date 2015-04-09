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
  - write tests with Teaspoon/Konacha
- data
  - add election model
  - add political parties to users and documents
  * delete records on user destroy
  * write request tests for users
  - move concerns to inheritance
  - set up DelayedJob to handle PDF creation
- government forms
  - handle political parties
  - handle elections
  - add mailing address to second page
- layout
  - create user page
  - put sign up/sign in in sidebar
  - create 404, 422, 500 pages
  - create logo
  - create /vision page
  - add flash messages to layout <%= notice %> <%= alert %>
- deploy
  * set up s3 with restricted access
  - restrict production access to preview routes
  - set up Unicorn
  - set up Mandrill
  - set up google analytics
  - set up with domain name
  - set up breezevote email
- bugs
  - weird inconsistent nil user when creating ballot request


#### Running tests ####

```sh
$ bundle exec rspec spec
```