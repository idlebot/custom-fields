# mixin module to help setting up an environment for integration tests
module IntegrationTestHelper
  def setup_user_accounts
    @user_custom_fields = User.create(name: 'custom_fields', email: 'custom_fields@email.com', password: 'password')
    user_custom_fields = @user_custom_fields.custom_fields
    @drop_down_custom_field = user_custom_fields.new(
      field_name: 'Drop Down Custom Field',
      type: DropDownCustomField.name
    )

    drop_down_values = @drop_down_custom_field.drop_down_values
    @drop_down_value = drop_down_values.new
    @drop_down_value.value = 'value'
    @drop_down_value.custom_field = @drop_down_custom_field

    @other_drop_down_value = drop_down_values.new
    @other_drop_down_value.value = 'other'
    @other_drop_down_value.custom_field = @drop_down_custom_field

    @drop_down_custom_field.save!

    @text_custom_field = user_custom_fields.new(
      field_name: 'Text Custom Field',
      type: TextCustomField.name
    )
    @text_custom_field.save!

    @text_area_custom_field = user_custom_fields.new(
      field_name: 'Text Area Custom Field',
      type: TextAreaCustomField.name
    )
    @text_area_custom_field.save!

    @user_no_custom_fields = User.create(name: 'no_custom_fields', email: 'no_custom_fields@email.com', password: 'password')
  end

  def setup_contacts
    @user_custom_fields_contact = @user_custom_fields.contacts.new
    @user_custom_fields_contact.name = 'Contact 1 name'
    @user_custom_fields_contact.email = 'contact1@email.com'
    @user_custom_fields_contact.save!

    @user_custom_fields_contact_drop_down_value = @drop_down_custom_field.custom_field_values.new
    @user_custom_fields_contact_drop_down_value.drop_down_value = @drop_down_value
    @user_custom_fields_contact_drop_down_value.contact = @user_custom_fields_contact
    @user_custom_fields_contact_drop_down_value.save!

    @user_custom_fields_contact_text_value = @text_custom_field.custom_field_values.new
    @user_custom_fields_contact_text_value.value = 'Text value'
    @user_custom_fields_contact_text_value.contact = @user_custom_fields_contact
    @user_custom_fields_contact_text_value.save!

    @user_custom_fields_contact_text_area_value = @text_area_custom_field.custom_field_values.new
    @user_custom_fields_contact_text_area_value.value = 'Text area value'
    @user_custom_fields_contact_text_area_value.contact = @user_custom_fields_contact
    @user_custom_fields_contact_text_area_value.save!

    @user_no_custom_fields_contact = @user_no_custom_fields.contacts.new
    @user_no_custom_fields_contact.name = 'Contact 2 name'
    @user_no_custom_fields_contact.email = 'contact1@email.com'
    @user_no_custom_fields_contact.save!
  end

  def login(user)
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: user.email, password: user.password } }
  end

  def logout
    delete logout_path
  end

  def create_custom_field_value_attribute(custom_field, value, custom_field_value = nil)
    attribute = {}
    attribute['value'] = value
    attribute['custom_field_id'] = custom_field.id.to_s
    attribute['id'] = custom_field_value.id.to_s if custom_field_value
    attribute
  end

  def create_custom_field_drop_down_value_attribute(custom_field, drop_down_value, custom_field_value = nil)
    attribute = {}
    attribute['drop_down_value_id'] = drop_down_value.id.to_s
    attribute['custom_field_id'] = custom_field.id.to_s
    attribute['id'] = custom_field_value.id.to_s if custom_field_value
    attribute
  end

  def drop_down_value_attributes(value, id = nil)
    attributes = {}
    attributes['value'] = value
    attributes['_destroy'] = 'false'
    attributes['id'] = id.to_s if id
    attributes
  end

  def drop_down_value_destroy_attributes(value, id)
    attributes = {}
    attributes['value'] = value
    attributes['_destroy'] = '1'
    attributes['id'] = id.to_s if id
    attributes
  end
end
