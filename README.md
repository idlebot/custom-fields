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

## How to use the editor
### Create an account
* Create an account by clicking on "Create account"
* Type a name, email and password

### Create one or more contacts
* Click on the Contacts link in the nav bar
* Click on the "new contact" button
* Enter a name and email and save the contact

### Customize the fields
* Click on the Custom Fields link in the nav bar
* Click on "Create custom field" button
* There are 3 types of custom fields: text, text area or drop down. You just have to enter the name of the custom field. Selecting a drop down, requires you also to enter a list of valid values for the drop down.

### Editing contacts with custom fields
* After creating one or more custom fields, creating a new contact or editing an existing contact will tave extra fields for all contacts.

## Development notes
### Gems
Only a few gems were added to the project:
* bcrypt to handle secure password hashing
* bootstrap-sass for styling
* rails-controller-test for controller test automation

### Model
Simplifying things a bit, there are only five entities in the application model:
* users
* contacts
* custom_fields
* custom_field_values
* drop_down_values

#### users
Represents a application user. Authentication information is stored here.

#### contacts
Store contacts. Each user may have multiple contacts.

#### custom_fields
Each user may have zero or more custom fields. A custom field may be of type Text, Text Area or Drop Down and has a field_name.

#### drop_down_values
If a custom field is of type Drop Down, then the custom field will have one or more drop_down_values associated. This is the set of valid values for the Drop Down custom field.

#### custom_field_values
If the user has defined custom fields, then each contact may have zero or more custom field values for each contact. Each custom field_value also holds a belongs_to relationship to custom_field. If the custom field is of type Drop Down, then custom field value will also store its value through a reference to drop_down_values.

#### Other notes

* Even though there are validation rules in each Rails model classes, whenever possible I also created database contraints to enforce things like foreign keys and required fields.

* Custom fields need to support three subtypes: text, text area and drop down. They were implemented using a single table inheritance model to represent all three types.

### JavaScript
In the custom field editor it is possible to dynamically add more drop down values. This was done without server interaction and was implemented in JavaScript code. The solution was adapted from Rails Cast episodes 196 and 197 and had to be modified to run in Rails 5. Basically, in order to be possible to add new values in the client code, an HTML fragment representing a new drop down value was stored inside an attribute and whenever the user adds a new value, the fragment is used as a template to create new input tags.

Another aspect was that the JavaScript was implemented in a unobtrusive manner. In order for this to work properly in Rails 5 and Turbolinks, it was necessary to use:

```
$(document).on('turbolinks:load', function()...
```

instead of:

```
$(document).ready(ready)...
```

Also, to avoid running unobtrusive JavaScript initialization in all pages when all JavaScript is compiled in a single bundle, such as in Rails, it was used a simplified version of the Garber-Irish technique:

<https://gist.github.com/danielgreen/5677251>

### Tests
The tests are focused on three main areas:
* Integration tests to ensure that the application user flows work. Eg. creating contacts, creating custom fields, editing contacts with custom fields, etc.
* Integration tests that ensure that that only logged users with proper permissions can perform certain actions such as editing a contact
* Model tests that ensure that the validation rules are working. I didn't create extensive tests for all possible validations. Instead, I focused on creating tests for complex validation rules only, such as "Drop Down Custom Field must have at least one Drop Down Value' or 'Contact cannot have duplicate values for the same custom field'
