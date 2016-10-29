class User < ApplicationRecord

  # attributes

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: { admin: 1, secretary: 2, educator: 3, student: 4 }

  # validations

  validates_uniqueness_of :email
  validates_presence_of :email, :password, :role
end
