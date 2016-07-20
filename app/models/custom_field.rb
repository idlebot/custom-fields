class CustomField < ActiveRecord::Base

  belongs_to :user

  validates :field_name,
    presence: true,
    length: { minimum: 2, maximum: 50 }

end

class TextCustomField < CustomField

end

class TextAreaCustomField < CustomField

end

class DropDownCustomField < CustomField
  has_many :drop_down_values, dependent: :destroy
end
