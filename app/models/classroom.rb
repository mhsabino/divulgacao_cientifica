class Classroom < ApplicationRecord

  # attributes

  enum period: { integral: 1, nightly: 2 }

  # associations

  belongs_to :discipline
  belongs_to :educator

  # validations

  validates_presence_of :period,
                        :vacancies,
                        :year,
                        :discipline

  validates :vacancies, numericality: { greater_than: 0 }

  # delegations

  delegate :name, to: :discipline, prefix: true, allow_nil: true
  delegate :name, to: :educator, prefix: true, allow_nil: true

end
