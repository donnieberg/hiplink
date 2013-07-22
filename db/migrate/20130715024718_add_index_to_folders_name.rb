class AddIndexToFoldersName < ActiveRecord::Migration
  def change
    add_index :folders, :name, unique: true
  end
end
