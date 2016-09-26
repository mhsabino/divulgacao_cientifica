class CreateClassrooms < ActiveRecord::Migration[5.0]
  def change
    create_table :classrooms do |t|
      t.references :discipline, foreign_key: true
      t.references :educator, foreign_key: true
      t.integer :period
      t.integer :vacancies
      t.string :year

      t.timestamps
    end
  end
end
