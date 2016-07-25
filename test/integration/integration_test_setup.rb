# mixin module to help setting up an environment for integration tests
module IntegrationTestSetup
  def create_environment
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
end
