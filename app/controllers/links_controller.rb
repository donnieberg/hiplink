class LinksController < ApplicationController
  def index
  # @folders = Folder.where soft_deleted: false
    Folder.create_folders!

    @links = Link.where soft_deleted: false
    Link.create_links! 
    @split_tag_array = []
    @links.map(&:tags).flatten.uniq.each do |full_tag|
      full_tag[:name].split(" ").each do |split_tag| 
        @split_tag_array << split_tag
      end
    end
  end

  def new
    @link = Link.new
  end

  def create
    @link = Link.new(params[:link])
    if @link.save
      flash[:success] = "Link successfully created."      
      redirect_to '/links'
    else
      flash[:error] = "Error, please try creating link again. Links must have a folder and cannot be duplicated."       
      render :new      
    end
  end

  def show
    @link = Link.find(params[:id])
  end

  def edit
    @link = Link.find(params[:id])    
  end

  def update
    @link = Link.find(params[:id])
    @updated_link = @link.update_attributes(params[:link])
    if @updated_link
      flash[:success] = "Link successfully updated."        
      render :show 
    else
      flash[:error] = "Error, please try editing link again."         
      render :new      
    end    
  end

  def destroy
    link = Link.find(params[:id])
    link.update_attribute(:soft_deleted, true)  
    flash[:success] = "Link was deleted."    
    redirect_to '/links'
  end
end
