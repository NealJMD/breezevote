Breezevote
==========

This Rails application is a website that manages the paperwork for absentee voting (and eventually all voting) for people who'd rather deal with that stuff on their computer or phone.

#### Todos ####

- enforce two letter state codes on addresses
- standardize and enforce country names, have .is_foreign? method
- switch to single table inheritance for models
- election model
- front end
- pdfs
- s3
- https
- user accounts

#### Running tests ####

```sh
$ bundle exec rspec spec
```