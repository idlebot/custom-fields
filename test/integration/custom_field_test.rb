require 'test_helper'
require_relative 'integration_test_helper'

# Test basic custom field operations
class CustomFieldTest < ActionDispatch::IntegrationTest

  include IntegrationTestHelper

  def setup
    setup_user_accounts
  end

  test 'Users cannot see each other custom fields' do
    login(@user_custom_fields)
    get custom_fields_path
    assert_template 'custom_fields/index'
    assert_select 'tbody tr', {count: 3}

    logout_path
    login(@user_no_custom_fields)
    get custom_fields_path
    assert_template 'custom_fields/index'
    assert_select 'tbody tr', {count: 0}
  end

  test 'Create new text custom field' do
    login(@user_no_custom_fields)
    get new_custom_field_path
    assert_template 'custom_fields/new'

    field_name = 'NewTextCustomField'

    assert_difference 'CustomField.count', 1 do
      post custom_fields_path, params: { custom_field: { type: TextCustomField.name, field_name: field_name } }
      follow_redirect!
    end

    assert_template 'custom_fields/index'
    assert_select 'tbody tr', {count: 1}
    assert_match field_name, response.body
  end

  test 'Create new text area custom field' do
    login(@user_no_custom_fields)
    get new_custom_field_path
    assert_template 'custom_fields/new'

    field_name = 'NewTextAreaCustomField'

    assert_difference 'CustomField.count', 1 do
      post custom_fields_path, params: { custom_field: { type: TextAreaCustomField.name, field_name: field_name } }
      follow_redirect!
    end

    assert_template 'custom_fields/index'
    assert_select 'tbody tr', {count: 1}
    assert_match field_name, response.body
  end

  test 'Drop down custom field must have at least one drop down value' do
    login(@user_no_custom_fields)
    get new_custom_field_path
    assert_template 'custom_fields/new'

    field_name = 'NewDropDownCustomField'

    assert_no_difference 'CustomField.count' do
      post custom_fields_path, params: {
        custom_field: {
          type: DropDownCustomField.name,
          field_name: field_name
        }
      }
    end

    assert_template 'custom_fields/new'
    assert_match 'must have at least one', response.body
  end

  test 'Create new drop down custom field' do
    login(@user_no_custom_fields)
    get new_custom_field_path
    assert_template 'custom_fields/new'

    field_name = 'NewDropDownCustomField'

    assert_difference 'CustomField.count', 1 do
      post custom_fields_path, params: {
        custom_field: {
          type: DropDownCustomField.name,
          field_name: field_name,
          drop_down_values_attributes: {
            "1469441463429": drop_down_value_attributes('value')
          }
        }
      }
      follow_redirect!
    end

    assert_template 'custom_fields/index'
    assert_select 'tbody tr', {count: 1}
    assert_match field_name, response.body
  end

  test 'delete custom field' do
    login(@user_custom_fields)
    assert_difference 'CustomField.count', -1 do
      delete custom_field_path(@drop_down_custom_field)
      follow_redirect!
    end

    assert_template 'custom_fields/index'
    assert_select 'tbody tr', {count: 2}
  end

  test 'edit custom field' do
    login(@user_custom_fields)
    field_name = 'Edited Text Custom Field'
    assert_no_difference 'CustomField.count' do
      put custom_field_path(@text_custom_field), params: {
        custom_field: {
          type: TextCustomField.name,
          field_name: field_name,
          drop_down_values_attributes: {
            "0": drop_down_value_attributes('')
          }
        }
      }
      follow_redirect!
    end

    assert_template 'custom_fields/index'
    assert_select 'tbody tr', {count: 3}
    assert_match field_name, response.body
  end

  test 'edit custom field add drop down value' do
    login(@user_custom_fields)
    field_name = @drop_down_custom_field.field_name

    assert_difference 'DropDownValue.count', 1 do
      put custom_field_path(@drop_down_custom_field), params: {
        custom_field: {
          type: DropDownCustomField.name,
          field_name: field_name,
          drop_down_values_attributes: {
            "0": drop_down_value_attributes('value', @drop_down_value.id.to_s),
            "1": drop_down_value_attributes('new value')
          }
        }
      }
      follow_redirect!
    end

    assert_template 'custom_fields/index'

    assert_select 'tbody tr', {count: 3}
    assert_match field_name, response.body
  end

  test 'edit custom field remove drop down value' do
    login(@user_custom_fields)
    field_name = @drop_down_custom_field.field_name
    assert_difference 'DropDownValue.count', -1 do
      put custom_field_path(@drop_down_custom_field), params: {
        custom_field: {
          type: DropDownCustomField.name,
          field_name: field_name,
          drop_down_values_attributes: {
            "0": drop_down_value_destroy_attributes('value', @drop_down_value.id.to_s)
          }
        }
      }
      follow_redirect!
    end

    assert_template 'custom_fields/index'

    assert_select 'tbody tr', {count: 3}
    assert_match field_name, response.body
  end

end
