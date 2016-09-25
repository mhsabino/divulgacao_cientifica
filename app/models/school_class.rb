class SchoolClass < ApplicationRecord

  # attributes

  enum period: { integral: 1, nightly: 2 }

  # associations

  belongs_to :course

  # validations

  validates_presence_of :name, :course, :year, :vacancies, :period
  validates :vacancies, numericality: { greater_than: 0 }

  # delegations

  delegate :name, to: :course, prefix: true, allow_nil: true

end
