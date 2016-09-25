class AddCourseIdToEducator < ActiveRecord::Migration[5.0]
  def change
    add_reference :educators, :course, foreign_key: true
  end
end
