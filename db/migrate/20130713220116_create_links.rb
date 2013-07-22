class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.date :date
      t.string :from
      t.string :link_url 
      t.timestamps
    end
  end
end

