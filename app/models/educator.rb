class Educator < ApplicationRecord

  # constants

  FILTER_METHODS = [:university, :course]
  SEARCH_METHODS = [:name, :registration]

  include Filterable
  include Searchable

  # associations

  belongs_to :university
  belongs_to :course
  belongs_to :user, dependent: :destroy

  has_many   :classrooms
  has_many   :disciplines, through: :classrooms
  has_many   :scientific_researches

  # validations

  validates_presence_of :name,
                        :registration,
                        :university,
                        :user,
                        :course_id

  validates_uniqueness_of :registration, scope: :university_id

  # delegations

  delegate :name,  to: :university, prefix: true, allow_nil: true
  delegate :name,  to: :course,     prefix: true, allow_nil: true
  delegate :email, to: :user,       allow_nil: true

  # nested attributes

  accepts_nested_attributes_for :user, allow_destroy: true, reject_if: :all_blank

  # methods

  def self.search(search_term)
    return all unless search_term
    by_name(search_term).or(by_registration(search_term))
  end

  # ordering

  def self.order_by_name
    order(:name)
  end

end
