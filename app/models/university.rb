class University < ApplicationRecord

  # associations

  has_many :educators, dependent: :destroy

  #validations

  validates_presence_of :name
end
