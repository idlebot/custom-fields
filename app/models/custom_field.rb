class CustomField < ActiveRecord::Base

  belongs_to :user
  has_many :drop_down_values, dependent: :destroy

  validates :field_name,
    presence: true,
    length: { minimum: 2, maximum: 50 }

end
