class CreateSchoolClasses < ActiveRecord::Migration[5.0]
  def change
    create_table :school_classes do |t|
      t.references :course, foreign_key: true
      t.string :name
      t.string :year
      t.integer :period
      t.integer :vacancies

      t.timestamps
    end
  end
end
