class Room < ActiveRecord::Base

attr_accessible :name, :description, :room_token_id

has_many :folders, dependent: :destroy
has_many :links, through: :folders

validates :room_token_id, presence: true,
            uniqueness: { case_sensitive: false }
end
