class User < ApplicationRecord

  # attributes

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: { admin: 1, secretary: 2, educator: 3, student: 4 }

  # associations

  has_one :educator, dependent: :destroy

  # validations

  validates_presence_of :email, :role
  validates_uniqueness_of :email
  validates_confirmation_of :password
end
