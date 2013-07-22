class AddSoftDeletedToLinks < ActiveRecord::Migration
  def change
    add_column :links, :soft_deleted, :boolean, default: false
  end
end
