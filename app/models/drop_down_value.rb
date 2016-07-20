class DropDownValue < ActiveRecord::Base

  belongs_to :user
  belongs_to :custom_field

  validates :value,
    presence: true,
    length: { minimum: 2, maximum: 50 }

end
