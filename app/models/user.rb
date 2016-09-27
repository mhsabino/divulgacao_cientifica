class User < ApplicationRecord

  # attributes

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # validations

  validates_uniqueness_of :email
  validates_presence_of :email
end
