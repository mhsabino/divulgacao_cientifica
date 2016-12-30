class Student < ApplicationRecord

  # constants

  FILTER_METHODS = [:university, :school_class]
  SEARCH_METHODS = [:name, :registration]
  ORDER_METHODS  = [:name]

  include Filterable
  include Searchable
  include Orderable

  # associations

  belongs_to :school_class
  belongs_to :university
  belongs_to :user
  has_one    :course, through: :school_class

  # validations

  validates_presence_of :name,
                        :university,
                        :school_class_id,
                        :registration,
                        :user

  validates_uniqueness_of :registration, scope: :university_id

  # delegations

  delegate :name,  to: :university,   prefix: true, allow_nil: true
  delegate :name,  to: :course,       prefix: true, allow_nil: true
  delegate :name,  to: :school_class, prefix: true, allow_nil: true
  delegate :email, to: :user,         allow_nil: true

  # nested attributes

  accepts_nested_attributes_for :user, allow_destroy: true, reject_if: :all_blank

end
