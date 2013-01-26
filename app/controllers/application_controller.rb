class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper
  include SessionsHelper
  
  before_filter :check_params
  
  def check_params
    if params[:signedin]
      if params[:signedin] == "false"
        flash.now[:error] = "You must sign in to do that, please sign in or make an account"
      end
    end
    
    if params[:downloaded]
      if params[:downloaded] == "true"
        flash.now[:success] = "Thanks for downloading, please don't forget to rate your downloads!"
      end
    end
    
    if params[:swag]
      @swag = params[:swag].to_i
    end
  end
  
end
