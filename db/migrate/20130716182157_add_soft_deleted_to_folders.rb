class AddSoftDeletedToFolders < ActiveRecord::Migration
  def change
    add_column :folders, :soft_deleted, :boolean, default: false
  end
end
