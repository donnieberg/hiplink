require 'hipchat-api'

class Folder < ActiveRecord::Base
  attr_accessible :name, :description
  before_save { |folder| folder.name = name.downcase }

  has_many :links, dependent: :destroy
  has_many :tags, through: :links

  validates :name, presence: true,
            uniqueness: { case_sensitive: false }

end