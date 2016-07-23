class Contact < ActiveRecord::Base

  belongs_to :user
  has_many :custom_field_values, dependent: :destroy

  before_save { self.email = email.downcase }

  validates :name,
    presence: true,
    length: { minimum: 2, maximum: 50 }

  validates :email,
    presence: true,
    length: { maximum: 100 },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

end
