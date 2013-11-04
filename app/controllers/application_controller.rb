class ApplicationController < ActionController::Base
  before_filter :my_var
  protect_from_forgery


  def my_var
    @rooms = Room.all
  end

end
