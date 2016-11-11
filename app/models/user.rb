class User < ApplicationRecord

  # attributes

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: { admin: 1, secretary: 2, educator: 3, student: 4 }

  # associations

  has_one :educator

  # validations

  validates_presence_of :email,
                        :password,
                        :password_confirmation,
                        :role

  validates_uniqueness_of :email
end
