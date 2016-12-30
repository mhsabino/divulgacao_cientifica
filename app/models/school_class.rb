class SchoolClass < ApplicationRecord

  # constants

  FILTER_METHODS = [:university, :course, :year, :period]
  SEARCH_METHODS = [:name]
  ORDER_METHODS  = [:name]

  include Filterable
  include Searchable
  include Orderable

  # attributes

  enum period: { integral: 1, nightly: 2 }

  # associations

  belongs_to :course
  belongs_to :university

  has_many :students

  # validations

  validates_presence_of :name,
                        :course_id,
                        :year,
                        :vacancies,
                        :period,
                        :university

  validates :vacancies, numericality: { greater_than: 0 }

  # delegations

  delegate :name, to: :course, prefix: true, allow_nil: true

  # nested attributes

  accepts_nested_attributes_for :students, allow_destroy: true,
    reject_if: :all_blank

  # methods

  def period_str
    SchoolClass.human_attribute_name("period.#{period}")
  end

  def self.localized_periods
    periods.keys.map { |w| [human_attribute_name("period.#{w}"), w] }
  end
end
