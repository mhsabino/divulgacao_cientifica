class Course < ApplicationRecord

  #associations

  belongs_to :university
  has_many :educators
  has_many :school_classes

  #validations

  validates_presence_of :name, :university

  # delegations

  delegate :name, to: :university, prefix: true, allow_nil: true
end