class CustomField < ActiveRecord::Base

  belongs_to :user

  validates :field_name,
    presence: true,
    length: { minimum: 2, maximum: 50 }

end
