class CustomFieldValue < ActiveRecord::Base

  belongs_to :contacts
  belongs_to :custom_field

end
