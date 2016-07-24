class CustomFieldValue < ActiveRecord::Base

  # optional must be true otherwise saving through accepts_nested_attributes_for
  # does not work
  belongs_to :contact, optional: true
  belongs_to :custom_field
  belongs_to :drop_down_value, optional: true

end
