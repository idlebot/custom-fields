require 'test_helper'

# DropDownCustomField model tests
class DropDownCustomFieldTest < ActiveSupport::TestCase

  def setup
    @user = User.new(
      name: 'Test User',
      email: 'email@email.com',
      password: 'password')
      @user.save!
  end

  test 'cannot save DropDownCustomField without at least one DropDownValue' do
    user_custom_fields = @user.custom_fields
    drop_down_custom_field = user_custom_fields.new(
      field_name: 'Drop Down Custom Field',
      type: DropDownCustomField.name)
    assert_not(drop_down_custom_field.save)
    assert_match(/must have at least one/, drop_down_custom_field.errors.full_messages[0])
  end

  test 'DropDownCustomField requires at least one DropDownValue' do
    user_custom_fields = @user.custom_fields
    drop_down_custom_field = user_custom_fields.new(
      field_name: 'Drop Down Custom Field',
      type: DropDownCustomField.name)

    drop_down_value = drop_down_custom_field.drop_down_values.new
    drop_down_value.value = 'value'
    drop_down_value.custom_field = drop_down_custom_field

    assert(drop_down_custom_field.save)
  end

  test 'DropDownCustomField with DropDownValue cannot be changed into TextCustomField' do
    user_custom_fields = @user.custom_fields
    drop_down_custom_field = user_custom_fields.new(
      field_name: 'Drop Down Custom Field',
      type: DropDownCustomField.name)

    drop_down_value = drop_down_custom_field.drop_down_values.new
    drop_down_value.value = 'value'
    drop_down_value.custom_field = drop_down_custom_field

    drop_down_custom_field.save

    drop_down_custom_field.type = TextCustomField.name
    assert_not(drop_down_custom_field.save)
    assert_match(/cannot have DropDownValue/, drop_down_custom_field.errors.full_messages[0])
  end

  test 'TextAreaCustomField cannot be changed into DropDownCustomField without adding a DropDownValue' do
    user_custom_fields = @user.custom_fields
    text_area_custom_field = user_custom_fields.new(
      field_name: 'Text Area Custom Field',
      type: TextAreaCustomField.name)

    assert(text_area_custom_field.save)

    text_area_custom_field.type = DropDownCustomField.name
    # saving without at least one DropDownValue must fail
    assert_not(text_area_custom_field.save)

    drop_down_value = text_area_custom_field.drop_down_values.new
    drop_down_value.value = 'value'
    drop_down_value.custom_field = text_area_custom_field

    # save now passes
    assert(text_area_custom_field.save)
  end

end
