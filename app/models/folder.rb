require 'hipchat-api'

class Folder < ActiveRecord::Base
  attr_accessible :name, :description
  before_save { |folder| folder.name = name.downcase }

  has_many :links, dependent: :destroy
  has_many :tags, through: :links


  validates :name, presence: true,
            uniqueness: { case_sensitive: false }

  def self.formatted_posts
    hipchat_api = HipChat::API.new('1da847ea86433056b28d93a85374bd')

    #room id, YYYY-MM-DD or 'recent' to get last 75 msg, timezone - june
    message_history = hipchat_api.rooms_history(216909, 'recent', 'US/Pacific') 

    all_postings = message_history['messages']
    all_postings.delete_if {|post| post['message'][0] != '_' }

    all_postings.each do |post|
      message = post['message']
      message_array = message.split(" ")
      message_hash = {}
      message_hash['underscore'] = message_array[0][1..-1]
      message_hash['link_url'] = message_array[1]
      post['message'] = message_hash
    end
    return all_postings
  end

  def self.create_folders!
    existing_folders = Folder.all
    formatted_posts.each do |post|
      should_create_folder = existing_folders.none? { |f| f.name == post['message']['underscore'] }
      Folder.create(name: post['message']['underscore'], description: "new folder") if should_create_folder     
    end   
  end
end