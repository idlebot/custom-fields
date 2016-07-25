# represents a possible value in a DropDownCustomField
class DropDownValue < ActiveRecord::Base
  belongs_to :custom_field, required: false
  has_many :custom_field_values, dependent: :destroy

  validates :value,
    presence: true,
    length: { minimum: 2, maximum: 50 }

  validates_uniqueness_of :value, scope: :custom_field_id

  validate :custom_field_must_be_drop_down_custom_field

  def custom_field_must_be_drop_down_custom_field
    drop_down_custom_field_type = DropDownCustomField.name
    if custom_field && custom_field.type != drop_down_custom_field_type
      errors.add(:custom_field, "Must be a #{drop_down_custom_field_type}")
    end
  end
end
