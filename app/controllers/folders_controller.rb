class FoldersController < ApplicationController
  
  def index
    # links = Link.where soft_deleted: false  
    # @links = links.sort!.reverse { |a, b| a.date <=> b.date }    
    # Link.create_links! 
    @folders = Folder.where soft_deleted: false
    Folder.create_folders!
  end

  def new
    @folder = Folder.new
  end

  def create #creates folder manually vs create method in Folder class which pulls hashtag name
    @folder = Folder.new(params[:folder])
    if @folder.save
      flash[:notice] = "Folder successfully created. Folder only appears if it contains links; go to New Link now."
      redirect_to '/folders'
    else
      flash[:error] = "Error, please try creating a folder again."   
      render :new    
    end 
  end

  def show
    @folder = Folder.find(params[:id])
    @split_tag_array = []
    @folder.links.map(&:tags).flatten.uniq.each do |full_tag|
      full_tag[:name].split(" ").each do |split_tag| 
        @split_tag_array << split_tag
      end
    end
  end

  def edit
    @folder = Folder.find(params[:id])    
  end

  def update
    @folder = Folder.find(params[:id])
    @updated_folder = @folder.update_attributes(params[:folder])
  
    if @updated_folder
      flash[:success] = "Folder successfully updated."      
      render :show 
    else
      flash[:error] = "Error, please try editing folder again."        
      render :new      
    end  
  end

  def destroy
    @folder = Folder.find(params[:id])
    @folder.update_attribute(:soft_deleted, true ) 
    @folder.links.each do |link|
      link.update_attribute(:soft_deleted, true)
    end   
    redirect_to '/folders'
  end
end
