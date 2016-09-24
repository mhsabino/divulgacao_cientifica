class Educator < ApplicationRecord

  #associations

  belongs_to :university

  #validations

  validates_presence_of :name,
                        :registration,
                        :university

  validates_uniqueness_of :registration, scope: :university_id

  # delegations

  delegate :name, to: :university, prefix: true, allow_nil: true
end
