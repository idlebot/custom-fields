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

  private
    def login
      get login_path
      assert_template 'sessions/new'
      post login_path, params: { session: { email: 'testuser@email.com', password: 'password' } }
    end

end
