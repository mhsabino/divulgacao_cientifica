class Discipline < ApplicationRecord

  # associations

  belongs_to :university
  belongs_to :course
  has_many   :classrooms

  # validations

  validates_presence_of :name,
                        :university,
                        :course

  validates_uniqueness_of :name, scope: :course_id

  # delegations

  delegate :name, to: :university, prefix: true, allow_nil: true
  delegate :name, to: :course,     prefix: true, allow_nil: true
end
