class User < ApplicationRecord
   has_secure_password

   has_many :posts, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { minimum: 2 }
end
