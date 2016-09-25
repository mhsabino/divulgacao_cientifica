class Student < ApplicationRecord

  # associations

  belongs_to :school_class
  belongs_to :university
  has_one    :course, through: :school_class

  # validations

  validates_presence_of :name, :university, :school_class, :email, :registration
  validates_uniqueness_of :registration, scope: :university_id

  # delegations

  delegate :name, to: :university, prefix: true, allow_nil: true
  delegate :name, to: :course, prefix: true, allow_nil: true
end
