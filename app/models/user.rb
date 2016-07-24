class User < ActiveRecord::Base
  has_many :contacts, dependent: :destroy
  has_many :custom_fields, dependent: :destroy

  before_save { self.email = email.downcase }

  validates :name,
    presence: true,
    length: { minimum: 2, maximum: 50 }

  validates :email,
    presence: true,
    length: { maximum: 100 },
    uniqueness: { case_sensitive: false },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  has_secure_password

end
