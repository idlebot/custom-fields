require 'test_helper'

# Test routes permissions
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

  private
    def login
      get login_path
      assert_template 'sessions/new'
      post login_path, params: { session: { email: 'testuser@email.com', password: 'password' } }
    end

end
