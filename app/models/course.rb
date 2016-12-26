class Course < ApplicationRecord

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

  # methods

  def self.by_name(name)
    where('name LIKE ?', "%#{name}%")
  end

  def self.by_university(university_id)
    where(university_id: university_id)
  end
end
