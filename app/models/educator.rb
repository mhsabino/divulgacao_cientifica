class Educator < ApplicationRecord

  # associations

  belongs_to :university
  belongs_to :course
  belongs_to :user
  has_many   :classrooms
  has_many   :disciplines, through: :classrooms
  has_many   :scientific_researches

  # validations

  validates_presence_of :name,
                        :registration,
                        :university,
                        :user

  validates_uniqueness_of :registration, scope: :university_id

  # delegations

  delegate :name, to: :university, prefix: true, allow_nil: true
  delegate :name, to: :course, prefix: true, allow_nil: true
  delegate :email, to: :user, allow_nil: true
end
