class AddFolderIdToLinks < ActiveRecord::Migration
  def change
    add_column :links, :folder_id, :integer    
  end
end
