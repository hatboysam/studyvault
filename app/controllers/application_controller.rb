class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  before_filter :check_download
  
  def check_download
    if params[:downloaded]
      if params[:downloaded] == "true"
        flash.now[:success] = "Thanks for downloading, please don't forget to rate your downloads!"
      end
    end
  end
  
end
