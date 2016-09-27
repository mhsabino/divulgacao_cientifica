class AddUserIdToEducator < ActiveRecord::Migration[5.0]
  def change
    add_reference :educators, :user, foreign_key: true
  end
end
