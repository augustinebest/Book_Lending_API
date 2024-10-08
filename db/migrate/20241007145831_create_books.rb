class CreateBooks < ActiveRecord::Migration[7.2]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.boolean :available

      t.timestamps
    end
  end
end
