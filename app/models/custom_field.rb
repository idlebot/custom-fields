# Base class for all custom field definitions
class CustomField < ActiveRecord::Base
  belongs_to :user

  has_many :custom_field_values, dependent: :destroy

  has_many :drop_down_values, dependent: :destroy, autosave: true

  accepts_nested_attributes_for :drop_down_values,
    reject_if: ->(drop_down_values) { drop_down_values[:value].blank? },
    allow_destroy: true

  validates :field_name,
    presence: true,
    length: { minimum: 2, maximum: 50 }

  validates_uniqueness_of :field_name, scope: :user_id

  validate :only_drop_down_custom_field_can_have_drop_down_values

  # in theory this validation should be be done in the inherited classes
  # however, in order to validate cases where the type is being changed from
  # DropDownCustomField to TextCustomField and vice-versa, it is much
  # easier to be done in the base class
  def only_drop_down_custom_field_can_have_drop_down_values
    drop_down_value_type = DropDownValue.name
    drop_down_value_count = drop_down_values.length
    if type == DropDownCustomField.name
      if drop_down_value_count.zero?
        errors.add(:type, "#{type} must have at least one #{drop_down_value_type}")
      end
    else
      if drop_down_value_count > 0
        errors.add(:type, "#{type} cannot have #{drop_down_value_type}")
      end
    end
  end

  def self.type_description(type)
    # converts DropDownCustomField -> Drop Down
    type[/(.*)(CustomField)$/, 1].underscore.titleize
  end

  def type_description
    CustomField.type_description(type)
  end
end
