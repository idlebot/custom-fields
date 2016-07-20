class Contact < ActiveRecord::Base
  
  belongs_to :user
  before_save { self.email = email.downcase }

  validates :name,
    presence: true,
    length: { minimum: 2, maximum: 50 }

  validates :email,
    presence: true,
    length: { maximum: 100 },
    uniqueness: { case_sensitive: false },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

end