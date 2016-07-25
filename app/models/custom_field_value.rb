class CustomFieldValue < ActiveRecord::Base

  # optional must be true otherwise saving through accepts_nested_attributes_for
  # does not work
  belongs_to :contact, optional: true
  belongs_to :custom_field
  belongs_to :drop_down_value, optional: true

  validates_uniqueness_of :custom_field_id, :scope => :contact_id

  validate :only_drop_down_custom_field_values_can_have_drop_down_value
  validate :drop_down_custom_field_values_must_have_drop_down_value

  def only_drop_down_custom_field_values_can_have_drop_down_value
    if drop_down_value
      drop_down_custom_field_type = DropDownCustomField.name
      unless custom_field && custom_field.type == drop_down_custom_field_type
        errors.add(:drop_down_value, "not allowed if custom field not of type #{drop_down_custom_field_type}")
      end
    end
  end

  def drop_down_custom_field_values_must_have_drop_down_value
    unless drop_down_value
      drop_down_custom_field_type = DropDownCustomField.name
      if custom_field && custom_field.type == drop_down_custom_field_type
        errors.add(:drop_down_value, "is required if custom field is of type #{drop_down_custom_field_type}")
      end
    end
  end

end
