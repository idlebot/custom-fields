class DropDownValue < ActiveRecord::Base

  belongs_to :custom_field, required: false
  has_many :custom_field_values, dependent: :destroy

  validates :value,
    presence: true,
    length: { minimum: 2, maximum: 50 }

  validates_uniqueness_of :value, :scope => :custom_field_id

end
