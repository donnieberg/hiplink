class FoldersController < ApplicationController

  def index
    Folder.create_folders!
    @folders = Folder.where(soft_deleted: false).sort! { |a, b| a.name <=> b.name }

    Link.create_links!
    @links = Link.where soft_deleted: false
  end

  def new
    @folder = Folder.new
  end

  def create #creates folder manually vs create method in Folder class which pulls hashtag name
    @folder = Folder.new(params[:folder])
    if @folder.save
      flash[:success] = "Folder successfully created. It only appears in the Folder list if it contains links."
      redirect_to '/folders'
    else
      flash[:error] = "Error, please try creating a folder again."
      render :new
    end
  end

  def show
    @folder = Folder.find(params[:id])
    @links = Link.where soft_deleted: false
    @split_tag_array = []
    @folder.links.map(&:tags).flatten.uniq.each do |full_tag|
      full_tag[:name].split(" ").each do |split_tag|
        @split_tag_array << split_tag
      end
    end

    @person_array = []
    @links.each do |link|
      @person_array << link.from
    end
    @person_array.uniq!
  end

  def edit
    @folder = Folder.find(params[:id])
  end

  def update
    @folder = Folder.find(params[:id])
    updated_folder = @folder.update_attributes(params[:folder])

    if updated_folder
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
    flash[:success] = "Folder was successfully deleted."
    redirect_to '/folders'
  end
end
