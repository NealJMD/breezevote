Breezevote
==========

This Rails application is a website that manages the paperwork for absentee voting (and eventually all voting) for people who'd rather deal with that stuff on their computer or phone.

#### Todos ####

- add flash messages to layout
  ```
  <p class="notice"><%= notice %></p>
  <p class="alert"><%= alert %></p>
  ```
- page to show completed form
- more complete validations
- homepage explaining current version
- /vision explaining future version
- move concerns to proper inheritance
- election model
- s3
- https
- heroku

#### Running tests ####

```sh
$ bundle exec rspec spec
```