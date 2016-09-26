class CreateDisciplines < ActiveRecord::Migration[5.0]
  def change
    create_table :disciplines do |t|
      t.references :university, foreign_key: true
      t.references :course, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
