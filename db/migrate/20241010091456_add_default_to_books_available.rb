class AddDefaultToBooksAvailable < ActiveRecord::Migration[7.2]
  def change
    change_column_default :books, :available, true
  end
end
