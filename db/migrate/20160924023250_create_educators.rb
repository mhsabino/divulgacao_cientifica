class CreateEducators < ActiveRecord::Migration[5.0]
  def change
    create_table :educators do |t|
      t.references :university, foreign_key: true
      t.string :name
      t.string :registration

      t.timestamps
    end
  end
end
