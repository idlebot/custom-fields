require 'test_helper'

# Test basic custom field operations
class CustomFieldTest < ActionDispatch::IntegrationTest

  def setup
    @user_custom_fields = User.create(name: 'custom_fields', email: 'custom_fields@email.com', password: 'password')
    user_custom_fields = @user_custom_fields.custom_fields
    @drop_down_custom_field = user_custom_fields.new(
      field_name: 'Drop Down Custom Field',
      type: DropDownCustomField.name)

    @drop_down_value = @drop_down_custom_field.drop_down_values.new
    @drop_down_value.value = 'value'
    @drop_down_value.custom_field = @drop_down_custom_field

    @drop_down_custom_field.save!

    @text_custom_field = user_custom_fields.new(
      field_name: 'Text Custom Field',
      type: TextCustomField.name)
    @text_custom_field.save!

    @text_area_custom_field = user_custom_fields.new(
      field_name: 'Text Area Custom Field',
      type: TextAreaCustomField.name)
    @text_area_custom_field.save!

    @user_no_custom_fields = User.create(name: 'no_custom_fields', email: 'no_custom_fields@email.com', password: 'password')
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
            "1469441463429": {
              "value"=>"value",
              "_destroy"=>"false"
            }
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
            "0": {
              "value"=>"",
              "_destroy"=>"false"
            }
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
            "0": {
              "value" => @drop_down_value.value,
              "_destroy" => "false",
              "id" => @drop_down_value.id.to_s
            },
            "1": {
              "value" => 'new value',
              "_destroy" => "false"
            }
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
            "0": {
              "value" => @drop_down_value.value,
              "_destroy" => "1",
              "id" => @drop_down_value.id.to_s
            }
          }
        }
      }
      follow_redirect!
    end

    assert_template 'custom_fields/index'

    assert_select 'tbody tr', {count: 3}
    assert_match field_name, response.body
  end

  private

  def login(user)
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: user.email, password: user.password } }
  end

  def logout
    delete logout_path
  end

end
