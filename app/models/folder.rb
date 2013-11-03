class Folder < ActiveRecord::Base
  attr_accessible :name, :description, :room_id
  before_save { |folder| folder.name = name.downcase }

  belongs_to :room
  has_many :links, dependent: :destroy
  has_many :tags, through: :links

end
