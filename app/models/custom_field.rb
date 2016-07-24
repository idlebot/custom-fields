class CustomField < ActiveRecord::Base

  belongs_to :user

  has_many :custom_field_values, dependent: :destroy

  has_many :drop_down_values, dependent: :destroy, autosave: true

  accepts_nested_attributes_for :drop_down_values,
    :reject_if => lambda { |custom_field| custom_field[:value].blank? },
    :allow_destroy => true

  validates :field_name,
    presence: true,
    length: { minimum: 2, maximum: 50 }

  validates_uniqueness_of :field_name, :scope => :user_id

end
