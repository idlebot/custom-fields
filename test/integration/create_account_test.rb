require 'test_helper'

# Test create account process
class CreateAccount < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(name: 'testuser', email: 'testuser@email.com', password: 'password')
  end

  test 'Create account happy path' do
    get signup_path
    assert_template 'users/new'

    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'newuser', email: 'newuser@email.com', password: 'password' } }
      follow_redirect!
    end

    assert_template 'contacts/index'
  end

  test 'Email already exists' do
    get signup_path
    assert_template 'users/new'

    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: 'testuser', email: 'testuser@email.com', password: 'password' } }
    end

    assert_template 'users/new'
  end
end
