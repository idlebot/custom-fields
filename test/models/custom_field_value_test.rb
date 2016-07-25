require 'test_helper'

# CustomFieldValue model tests
class CustomFieldValueTest < ActiveSupport::TestCase

  def setup
    @user = User.new(
      name: 'Test User',
      email: 'email@email.com',
      password: 'password')
    @user.save!

    user_custom_fields = @user.custom_fields
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

    @contact = @user.contacts.new
    @contact.name = 'Test Contact'
    @contact.email = 'email@test.com'
    @contact.save!
  end

  test 'CustomFieldValue of type Text or Text Area cannot have drop_down_value associated' do
    text_value = @contact.custom_field_values.new
    text_value.custom_field = @text_custom_field
    text_value.value = 'Text Value'
    assert(text_value.valid?)
    text_value.drop_down_value = @drop_down_value
    assert_not(text_value.valid?)
    assert_match(/not allowed/, text_value.errors.full_messages[0])

    text_area_value = @contact.custom_field_values.new
    text_area_value.custom_field = @text_area_custom_field
    text_area_value.value = 'Text Area Value'
    assert(text_area_value.valid?)
    text_area_value.drop_down_value = @drop_down_value
    assert_not(text_area_value.valid?)
    assert_match(/not allowed/, text_area_value.errors.full_messages[0])
  end

  test 'CustomFieldValue of type Drop Down must have drop_down_value associated' do
    drop_down_value = @contact.custom_field_values.new
    drop_down_value.custom_field = @drop_down_custom_field
    assert_not(drop_down_value.valid?)
    drop_down_value.drop_down_value = @drop_down_value
    assert(drop_down_value.valid?)
  end

  test 'multiple custom field values for the same custom field in the same contact is not allowed' do
    text_value = @contact.custom_field_values.new
    text_value.custom_field = @text_custom_field
    text_value.value = 'Text Value'
    assert(@contact.save)

    duplicated_text_value = @contact.custom_field_values.new
    duplicated_text_value.custom_field = @text_custom_field
    duplicated_text_value.value = 'Text Value Duplicated'
    assert_not(@contact.save)

  end



end
