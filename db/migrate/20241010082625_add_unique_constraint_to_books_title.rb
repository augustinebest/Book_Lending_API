class AddUniqueConstraintToBooksTitle < ActiveRecord::Migration[7.2]
  def change
    add_index :books, :title, unique: true
  end
end
