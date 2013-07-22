require 'hipchat-api'

hipchat_api = HipChat::API.new('1fc2ac7967316af15f9d93595ae4e6')

#room id, YYYY-MM-DD or 'recent' to get last 75 msg, timezone
message_history = hipchat_api.rooms_history(237908, 'recent', 'US/Pacific') 

all_postings = message_history['messages']

all_postings.each do |post|
  message = post['message']
  message_array = message.split(" ")
  message_hash = {}
  message_hash['hash_tag'] = message_array[0][1..-1]
  message_hash['link_url'] = message_array[1]
  message_hash['tags'] = message_array[2..-1]
  post['message'] = message_hash
end

puts all_postings



    # make hip chat api call
    # all_postings = Folder.map_attributes('api_results)'

    # for each folder, create Folder model, store Folders in array called @folders (instance var)
    # the render :@folders  