require 'test_helper'
require_relative 'integration_test_helper'

# Test basic contact operations
class ContactTest < ActionDispatch::IntegrationTest

  include IntegrationTestHelper

  def setup
    setup_user_accounts
    setup_contacts
  end

  test 'Users cannot see each other contacts' do
    login(@user_custom_fields)
    get contacts_path
    assert_template 'contacts/index'
    assert_match @user_custom_fields_contact.name, response.body

    logout_path
    login(@user_no_custom_fields)
    get contacts_path
    assert_template 'contacts/index'
    assert_match @user_no_custom_fields_contact.name, response.body
  end

  test 'Users cannot edit each other contacts' do
    login(@user_custom_fields)
    get edit_contact_path(@user_no_custom_fields_contact)
    follow_redirect!
    assert_template 'contacts/index'
  end

  test 'create new contact no custom fields' do
    login(@user_no_custom_fields)
    get new_contact_path
    assert_template 'contacts/new'
    assert_difference 'Contact.count', 1 do
      post contacts_path, params: { contact: { name: 'Hello', email: 'hello@world.com' } }
    end

    follow_redirect!
    assert_template 'contacts/index'
  end

  test 'create new contact with custom fields' do
    login(@user_custom_fields)
    get new_contact_path
    assert_template 'contacts/new'
    assert_difference 'Contact.count', 1 do
      post(contacts_path, params: {
        contact: {
          name: 'Hello',
          email: 'hello@world.com',
          custom_field_values_attributes: {
            '0': create_custom_field_value_attribute(@text_custom_field, 'text value'),
            '1': create_custom_field_value_attribute(@text_area_custom_field, 'text value'),
            '2': create_custom_field_drop_down_value_attribute(@drop_down_custom_field, @drop_down_value)
          }
        }
      })
    end

    follow_redirect!
    assert_template 'contacts/index'
  end

  test 'delete contact' do
    login(@user_custom_fields)
    assert_difference 'Contact.count', -1 do
      delete contact_path(@user_custom_fields_contact)
    end

    follow_redirect!
    assert_template 'contacts/index'
  end

  test 'cannot delete other user''s contact' do
    login(@user_no_custom_fields)
    assert_no_difference 'Contact.count' do
      delete contact_path(@user_custom_fields_contact)
    end

    follow_redirect!
    assert_template 'contacts/index'
  end

  test 'edit contact with custom fields' do
    login(@user_custom_fields)
    get edit_contact_path(@user_custom_fields_contact)

    edited_name = 'Hello Edited'
    edited_email = 'hello_edited@world.com'
    edited_text_value = 'edited text value'
    edited_text_area_value = 'edited text area value'

    assert_template 'contacts/edit'
      put(contact_path(@user_custom_fields_contact), params: {
        contact: {
          name: edited_name,
          email: edited_email,
          custom_field_values_attributes: {
            '0': create_custom_field_value_attribute(@text_custom_field, edited_text_value, @user_custom_fields_contact_text_value),
            '1': create_custom_field_value_attribute(@text_area_custom_field, edited_text_area_value, @user_custom_fields_contact_text_area_value),
            '2': create_custom_field_drop_down_value_attribute(@drop_down_custom_field, @other_drop_down_value, @user_custom_fields_contact_drop_down_value)
          }
        }
      })

    follow_redirect!
    assert_template 'contacts/index'

    edited_contact = Contact.find(@user_custom_fields_contact.id)
    assert_equal(edited_contact.name, edited_name)
    assert_equal(edited_contact.email, edited_email)
    edited_text_custom_field_value = CustomFieldValue.find(@user_custom_fields_contact_text_value.id)
    assert_equal(edited_text_custom_field_value.value, edited_text_value)
    edited_text_area_custom_field_value = CustomFieldValue.find(@user_custom_fields_contact_text_area_value.id)
    assert_equal(edited_text_area_custom_field_value.value, edited_text_area_value)
    edited_drop_down_custom_field_value = CustomFieldValue.find(@user_custom_fields_contact_drop_down_value.id)
    assert_equal(edited_drop_down_custom_field_value.drop_down_value, @other_drop_down_value)
  end

end
