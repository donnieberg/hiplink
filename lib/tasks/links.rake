namespace :load do
desc "load in new links and folders from hipchat for various rooms"

	task :links => :environment do
		puts "hello, load_links task is working"

		def formatted_posts(roomId)
			hipchat_api = HipChat::API.new('1fc2ac7967316af15f9d93595ae4e6')
			#room id, YYYY-MM-DD or 'recent' to get last 75 msg, timezone - june
			today = Time.now.strftime("%Y-%m-%d")
			message_history = hipchat_api.rooms_history(roomId, today, 'US/Pacific')

			all_postings = message_history['messages']
			all_postings.delete_if {|post| post['message'][0] != '/' }

			all_postings.each do |post|
				message = post['message']
				message_array = message.split(" ")
				next if message_array.length < 2
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
			existing_folders = Folder.all
			formatted_posts(roomId).each do |post|
				should_create_folder = existing_folders.none? { |f| f.name == post['message']['forward_slash'] }
				find(roomId).folders.build(name: post['message']['forward_slash'], description: "new folder") if should_create_folder
			end
		end


		def create_links(roomId)
			existing_links = Link.all
			formatted_posts(roomId).each do |post|
				should_create_link = existing_links.none? {|l| l.link_url == post['message']['link_url'] }
				if should_create_link
					f = Folder.find_by_name(post['message']['forward_slash'])
					if f
						new_link = Link.create
						new_link.date = post['date']
						new_link.from = post['from']['name']
						new_link.link_url = post['message']['link_url']
						new_link.folder_id = f.id
						new_link.tag_list = post['message']['tags']
						new_link.save
					end
				end
			end
		end

# Hipchat Test Room
	create_folders(244599)
	create_links(244599)

# WDI SF Sept - Social
	create_folders(295105)
	create_links(295105)

# WDI SF Sept - Snakes
	create_folders(289202)
	create_links(289202)

# WDI SF Sept - Camels
	create_folders(289203)
	create_links(289203)

# WDI SF Sept Instructors
	create_folders(289873)
	create_links(289873)

	end
end
