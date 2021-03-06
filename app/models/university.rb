class University < ApplicationRecord

  # associations

  has_many :educators, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_many :disciplines, dependent: :destroy
  has_many :scientific_researches, dependent: :destroy
  has_many :students, dependent: :destroy

  # validations

  validates_presence_of :name
end
