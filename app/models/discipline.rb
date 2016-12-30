class Discipline < ApplicationRecord

  # constants

  FILTER_METHODS = [:university, :course]
  SEARCH_METHODS = [:name]
  ORDER_METHODS  = [:name]

  include Filterable
  include Searchable
  include Orderable

  # associations

  belongs_to :university
  belongs_to :course
  has_many   :classrooms

  # validations

  validates_presence_of :name,
                        :university,
                        :course_id

  validates_uniqueness_of :name, scope: :course_id

  # delegations

  delegate :name, to: :university, prefix: true, allow_nil: true
  delegate :name, to: :course,     prefix: true, allow_nil: true
end
