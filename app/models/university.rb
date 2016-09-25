class University < ApplicationRecord

  # associations

  has_many :educators, dependent: :destroy
  has_many :courses, dependent: :destroy

  #validations

  validates_presence_of :name
end