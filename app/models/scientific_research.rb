class ScientificResearch < ApplicationRecord

  # associations

  belongs_to :educator
  belongs_to :university

  # validations

  validates_presence_of :name,
                        :educator,
                        :university

  # delegations

  delegate :name, to: :university, prefix: true, allow_nil: true
  delegate :name, to: :educator, prefix: true, allow_nil: true

end
