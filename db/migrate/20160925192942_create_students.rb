class CreateStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :students do |t|
      t.references :school_class, foreign_key: true
      t.string :name
      t.string :registration
      t.string :email
      t.references :university, foreign_key: true

      t.timestamps
    end
  end
end
