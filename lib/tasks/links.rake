require 'hipchat-api'

namespace :load do
desc "load in new links and folders from hipchat for various rooms"

	task :links => :environment do
		puts "hello, load_links task is starting"

		def formatted_posts(roomId)
			#hipchat_api = HipChat::API.new('1fc2ac7967316af15f9d93595ae4e6')
			#GA's Rooms
			hipchat_api = HipChat::API.new('3b66cd25f1fdd374768bdbf79c8230')

			#room id, YYYY-MM-DD or 'recent' to get last 75 msg, timezone - june
			today = Time.now.strftime("%Y-%m-%d")
			message_history = hipchat_api.rooms_history(roomId, today, 'US/Pacific')

			all_postings = message_history['messages']
			if !all_postings.nil?
			all_postings.delete_if {|post| post['message'][0] != '/' }

			if all_postings.length > 0
				all_postings.select! do |post|
					message = post['message']
					message_array = message.split(" ")
					message_array.length > 2
				end

				all_postings.each do |post|
						message = post['message']
						message_array = message.split(" ")
						message_hash = {}
						message_hash['forward_slash'] = message_array[0][1..-1]
						message_hash['link_url'] = message_array[1]
						tag_array = []
						message_array[2..-1].each do |tag|
							tag_array << tag
						end
						tag_array.map! { |x| x[1..-1] }
						message_hash['tags'] = tag_array
						post['message'] = message_hash
				end
			end
			else
			  puts "there are no messages to get loaded from #{roomId}"
			end
			return all_postings
		end

		def find(roomId)
			all_rooms = Room.all
			all_rooms.select! do |room|
				room.room_token_id == roomId
			end
			return all_rooms.first
		end

		def create_folders(roomId)
			existing_folders = find(roomId).folders
			formatted_posts(roomId).each do |post|
				should_create_folder = existing_folders.none? { |f| f.name == post['message']['forward_slash'] }
				if should_create_folder
			    Folder.create(name: post['message']['forward_slash'], description: "new folder", room_id: find(roomId).id)
				end
			end
		end

		def create_links(roomId)
			existing_folders = find(roomId).folders
			# existing_links = Link.all
			formatted_posts(roomId).each do |post|
				# should_create_link = existing_links.none? {|l| l.link_url == post['message']['link_url'] }
				# if should_create_link
					f = existing_folders.select {|folder| folder.name == post['message']['forward_slash']}
					if f
						new_link = Link.create
						new_link.date = post['date']
						new_link.from = post['from']['name']
						new_link.link_url = post['message']['link_url']
						new_link.folder_id = f[0].id
						new_link.tag_list = post['message']['tags']
						new_link.save
					end
				#end
			end
		end

# Hipchat Test Room
# 	if !formatted_posts(244599).nil? && formatted_posts(244599).length > 0
#	  create_folders(244599)
#	  create_links(244599)
#	end

# # WDI SF Sept - Social
  	if !formatted_posts(295105).nil? && formatted_posts(295105).length > 0
 	  create_folders(295105)
  	  create_links(295105)
 	end

# # WDI SF Sept - Snakes
   	if !formatted_posts(289202).nil?  && formatted_posts(289202).length > 0
  	  create_folders(289202)
  	  create_links(289202)
 	end

# # WDI SF Sept - Camels
   	if !formatted_posts(289203).nil?  && formatted_posts(289203).length > 0
  	  create_folders(289203)
  	  create_links(289203)
 	end

# # WDI SF Sept Instructors
   	if !formatted_posts(289873).nil?  && formatted_posts(289873).length > 0
  	  create_folders(289873)
  	  create_links(289873)
 	end

	end
end
