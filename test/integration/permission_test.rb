require 'test_helper'

# Test route permissions
class PermissionTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(name: 'testuser', email: 'testuser@email.com', password: 'password')
  end

  test 'Contact index succeeds with user logged in' do
    login
    get contacts_path
    assert_template 'contacts/index'
  end

  test 'Contact index must fail if not logged in' do
    get contacts_path
    follow_redirect!
    assert_template 'pages/home'
  end

  test 'Custom field index succeeds with user logged in' do
    login
    get custom_fields_path
    assert_template 'custom_fields/index'
  end

  test 'Custom field index must fail if not logged in' do
    get custom_fields_path
    follow_redirect!
    assert_template 'pages/home'
  end

  test 'edit custom field must fail if not logged in' do
    assert_no_difference 'CustomField.count' do
      put custom_field_path(1), params: {
        custom_field: {
          type: DropDownCustomField.name,
          field_name: 'hello',
          drop_down_values_attributes: {
            "0": {
              "value" => 'value',
              "_destroy" => "1",
              "id" => 0
            }
          }
        }
      }
    end
    follow_redirect!
    assert_template 'pages/home'
  end

  test 'create custom field must fail if not logged in' do
    assert_no_difference 'CustomField.count' do
      post custom_fields_path, params: {
        custom_field: {
          type: DropDownCustomField.name,
          field_name: 'hello',
          drop_down_values_attributes: {
            "0": {
              "value" => 'value',
              "_destroy" => "1",
              "id" => 0
            }
          }
        }
      }
    end
    follow_redirect!
    assert_template 'pages/home'
  end

  test 'delete custom field  must fail if not logged in' do
    assert_no_difference 'CustomField.count' do
      delete custom_field_path(1)
    end
    follow_redirect!
    assert_template 'pages/home'
  end

  private
  def login
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: 'testuser@email.com', password: 'password' } }
  end

end
