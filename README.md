# Custom Fields Demo App

My first Rails App.

* Demonstrates dynamically adding fields to a Rails form
* Implements basic user authentication

## Setup

Requirements:
* Local PostgreSQL 9.X database engine installed
* Ruby 2.3.1 and Rails 5.0.0

Create the following environment variables:

```
export CUSTOM_FIELDS_DATABASE_PASSWORD={Postgres Password}
export CUSTOM_FIELDS_DATABASE_USERNAME={Postgres Username}
```

Go to the application directory and type:

```
bundle install
rake db:create
rake db:migrate
rails server
```

Navigate to <http://localhost:3000>
or <http://custom-fields-marcelo.herokuapp.com/> for a hosted version on Heroku.
