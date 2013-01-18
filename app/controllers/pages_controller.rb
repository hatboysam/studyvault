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

  def search
    @uploads = []
    @school_name = params[:school]
    @school = School.find_by_name(@school_name)
    @course_name = params[:course]
    @course = Course.find_by_full_name(@course_name)
    @professor_name = params[:professor]
    if (params[:match] == "ALL")
      conditions = {}
      conditions[:school_id] = @school.id unless (@school_name.blank? || @school.nil?)
      conditions[:course_id] = @course.id unless (@course_name.blank? || @course.nil?)
      conditions[:professor] = @professor_name unless (@professor_name.nil?)
      @uploads = Upload.find(:all, :conditions => conditions)
    else
      @uploads = @uploads.concat(Upload.where(:school_id => @school.id)) unless @school.nil?
      @uploads = @uploads.concat(Upload.where(:course_id => @course.id)) unless @course.nil?
      @uploads = @uploads.concat(Upload.where(:professor => @professor_name)) unless @professor_name.blank?
    end
  end
  
  def about
    
  end
  
  def aboutswag
    
  end
  
  def terms
    
  end

end

