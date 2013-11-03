class RoomsController < ApplicationController

def index
  @rooms = Room.all
end  

def new
  @room = Room.new
end

def create
  @room = Room.new(params[:room])
  if @room.save
    flash[:success] = "Yay"
    render :index
  else
    flash[:danger] = "not created"
    render :new
  end
end

end
