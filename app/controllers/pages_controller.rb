class PagesController < ApplicationController
  
  before_filter :authenticate, :only => [:upload]

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
    
    @professors = @raw.map(&:professor).uniq.each_with_index.map{|x,i| {id: i, value: x}}
    
    respond_to do |format|
      format.js
    end
  end

  def upload
    if signed_in?
      @user = current_user
      @upload = Upload.new
      @subjects = current_user.school.subjects
    end
  end

  def search
    @uploads = []
    school_name = params[:school]
    #Auto suggest the user's school
    if school_name.nil?
      @school_placeholder = current_user.school.name unless current_user.nil?
    else
      @school_placeholder = school_name
    end
    #Find the requested course and school in the database
    @subject = params[:subject]
    @course_code = params[:course_code]
    @course_name = params[:course_name]
    #@course_name = [@subject, @course_code].join(' ')
    @professor_name = params[:professor]
    course = Course.find_by_full_name(@course_name)
    @school = School.find_by_name(school_name)
    #Use conditions either for ANY or ALL, ignoring blank either way
    if (params[:match] == "ALL")
      conditions = {}
      conditions[:school_id] = @school.id unless (school_name.blank? || @school.nil?)
      conditions[:course_id] = course.id unless (@course_name.blank? || course.nil?)
      conditions[:professor] = @professor_name unless (@professor_name.blank? || @professor_name.nil?)
      @uploads = Upload.find(:all, :conditions => conditions)
    else
      @uploads = @uploads.concat(Upload.where(:school_id => @school.id)) unless @school.nil?
      @uploads = @uploads.concat(Upload.where(:professor => @professor_name)) unless @professor_name.blank?
      @uploads = @uploads.concat(Upload.where(:course_id => course.id)) unless course.nil?
    end
  end
  
  def about
    
  end
  
  def aboutswag
    
  end
  
  def terms
    
  end

end

