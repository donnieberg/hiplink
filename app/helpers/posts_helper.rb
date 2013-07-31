module PostsHelper

  def format(message_history)
    all_postings = message_history['messages']
    all_postings.delete_if {|post| post['message'][0] != '_' }
    # all_postings.delete_if {|post| post['message'].match(" ").nil? }

    all_postings.each do |post|
      message = post['message']
      message_array = message.split(" ")
      message_hash = {}
      message_hash['underscore'] = message_array[0][1..-1]
      post['message'] = message_hash
    end
    return all_postings
  end

end