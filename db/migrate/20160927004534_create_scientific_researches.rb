class CreateScientificResearches < ActiveRecord::Migration[5.0]
  def change
    create_table :scientific_researches do |t|
      t.references :educator, foreign_key: true
      t.references :university, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
