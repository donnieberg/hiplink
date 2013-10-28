require 'hipchat-api'

class Link < ActiveRecord::Base
  attr_accessible :date, :from, :link_url, :folder_id, :tag_list

  belongs_to :folder

  validates :date, presence: true
  validates :from, presence: true
  validates :link_url, presence: true, uniqueness: { case_sensitive: false }

  acts_as_taggable
  acts_as_taggable_on :tags

end
