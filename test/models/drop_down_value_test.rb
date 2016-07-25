require 'test_helper'

# DropDownValue model tests
class DropDownValueTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: 'Test User',
      email: 'email@email.com',
      password: 'password'
    )
    @user.save!

    user_custom_fields = @user.custom_fields
    @drop_down_custom_field = user_custom_fields.new(
      field_name: 'Drop Down Custom Field',
      type: DropDownCustomField.name
    )

    @drop_down_value = @drop_down_custom_field.drop_down_values.new
    @drop_down_value.value = 'value'
    @drop_down_value.custom_field = @drop_down_custom_field

    @drop_down_custom_field.save!

    @text_custom_field = user_custom_fields.new(
      field_name: 'Text Custom Field',
      type: TextCustomField.name
    )

    @text_custom_field.save!
  end

  test 'valid drop down value' do
    drop_down_value = @drop_down_custom_field.drop_down_values.new
    drop_down_value.value = 'valid'
    Rails.logger.debug drop_down_value
    assert drop_down_value.valid?
  end

  test 'value is required' do
    drop_down_value = @drop_down_custom_field.drop_down_values.new
    assert_not drop_down_value.valid?
  end

  test 'TextCustomField does not allow drop down values' do
    new_drop_down_value = @text_custom_field.drop_down_values.new
    new_drop_down_value.value = 'hello'
    new_drop_down_value.custom_field = @text_custom_field
    assert_not new_drop_down_value.valid?
  end

  test 'only DropDownCustomField does allows drop down values' do
    new_drop_down_value = @drop_down_custom_field.drop_down_values.new
    new_drop_down_value.value = 'hello'
    new_drop_down_value.custom_field = @drop_down_custom_field
    assert new_drop_down_value.valid?
  end

  test 'same DropDownCustomField cannot have duplicated DropDownValue values' do
    new_drop_down_value = @drop_down_custom_field.drop_down_values.new
    new_drop_down_value.value = 'value' # already exists
    new_drop_down_value.custom_field = @drop_down_custom_field
    assert_not new_drop_down_value.valid?
    assert_match(/been taken/, new_drop_down_value.errors.full_messages[0])
  end
end
