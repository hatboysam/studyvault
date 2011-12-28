class PagesController < ApplicationController
  
  def index
    if signed_in?
      @user = current_user
      @upload = Upload.new
    end
    @uploads = Upload.all.paginate(:page => params[:page], :per_page => 5)
  end

end

