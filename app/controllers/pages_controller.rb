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
        @raw = current_user.school.uploads.find(:all, :limit => 20, :conditions => ['professor LIKE ?', "#{@search}%"])
      else
        @raw = current_user.school.uploads.find(:all, :limit => 20, :conditions => ['professor ILIKE ?', "#{@search}%"])
      end
    else
      @raw = current_user.school.uploads.find(:all, :limit => 20)
    end
    
    @professors = @raw.each_with_index.map{|x,i| {id: i, value: x.professor}}
    
    respond_to do |format|
      format.js
    end
  end

  def upload
    if signed_in?
      @user = current_user
      @upload = Upload.new
    end
  end
  
  def about
    
  end
  
  def aboutswag
    
  end
  
  def terms
    
  end

end

