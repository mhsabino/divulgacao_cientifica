class AddUniversityIdToSchoolClass < ActiveRecord::Migration[5.0]
  def change
    add_reference :school_classes, :university, foreign_key: true
  end
end
