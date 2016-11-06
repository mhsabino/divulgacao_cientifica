class User < ApplicationRecord

  # attributes

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: { admin: 1, secretary: 2, educator: 3, student: 4 }

  # validations

  validates_presence_of :email,
                        :password,
                        :role

  validates_uniqueness_of :email
end
