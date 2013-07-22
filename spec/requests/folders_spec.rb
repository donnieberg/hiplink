require 'spec_helper'

describe "Folders" do
  it { should have_many(:links) }
  it { should have_many(:tags).through(:links) }

  describe "Folders Index Page" do
  end

end
