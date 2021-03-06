class Course < ApplicationRecord

  # constants

  FILTER_METHODS = [:university]
  SEARCH_METHODS = [:name]
  ORDER_METHODS  = [:name]

  include Filterable
  include Searchable
  include Orderable

  # associations

  belongs_to :university
  has_many   :educators
  has_many   :school_classes
  has_many   :disciplines

  # validations

  validates_presence_of :name,
                        :university

  validates_uniqueness_of :name, scope: :university_id

  # delegations

  delegate :name, to: :university, prefix: true, allow_nil: true

end
