# == Schema Information
#
# Table name: folders
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Folder do
  before do
    @folder = Folder.new(name: "Foldername", description: "Here's my description")
  end
  
  describe "when folder name is already taken" do
    before do
      folder_with_same_name = @folder.dup
      folder_with_same_name.name = @folder.name.upcase      
      folder_with_same_name.save
    end

    it { should_not be_valid }
  end
end
