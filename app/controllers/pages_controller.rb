class PagesController < ApplicationController
  
  def index
    if signed_in?
      @user = current_user
      @upload = Upload.new
      @purchase = Purchase.new
    end
  end
  
  def professors
    if params[:term]
      @search = params[:term]
      if ENV['RAILS_ENV'] == "development"
        @raw = current_user.school.uploads.find(:all, :conditions => ['professor LIKE ?', "#{@search}%"])
      else
        @raw = current_user.school.uploads.find(:all, :conditions => ['professor ILIKE ?', "#{@search}%"])
      end
    else
      @raw = current_user.school.uploads
    end
    
    @professors = @raw.map(&:professor).first(10).uniq
    
    respond_to do |format|
      format.js
    end
  end
  
  def about
    
  end
  
  def terms
    
  end

end

