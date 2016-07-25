require 'test_helper'

# Login/logout test cases
class LoginLogoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(name: 'testuser', email: 'testuser@email.com', password: 'password')
  end

  test 'Successful login' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: 'testuser@email.com', password: 'password' } }
    follow_redirect!
    get contacts_path
    assert_template 'contacts/index'
  end

  test 'Invalid login attempt' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: 'testuser@email.com', password: 'INVALID' } }
    assert_template 'sessions/new'

    assert_select 'div[id=flash_danger]', 'There was something wrong with your login information'
  end

  test 'Logout' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: 'testuser@email.com', password: 'password' } }
    follow_redirect!
    get contacts_path
    assert_template 'contacts/index'

    delete logout_path
    follow_redirect!
    assert_template 'pages/home'
  end
end
