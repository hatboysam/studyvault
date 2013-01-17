class CoursesController < ApplicationController
  
  before_filter :authenticate
  
  def index
    if params[:term]
      @split = params[:term].split(' ', 2)
      @subject = @split.first
      @code = @split.last
      if ENV['RAILS_ENV'] == "development"
        @courses = current_user.school.courses.find(:all, :limit => 20, :conditions => ['full_name LIKE ? OR full_name LIKE ?', "%#{@subject}%", "%#{@code}%"])
      else
        @courses = current_user.school.courses.find(:all, :limit => 20, :conditions => ['full_name ILIKE ? OR full_name ILIKE ?', "%#{@subject}%", "%#{@code}%"])
      end
    else
      @courses = Course.find(:all, :limit => 20)
    end
    
    @course_names = @courses.map{|x| {id: x.id, value: x.full_name}}
    
    respond_to do |format|
      format.html
      format.js
      format.json do
        @courses.map! do |u|
          {
            :label => u.course_name,
            :value => u.id
          }
        end
        render :json => @courses
      end
    end
  end
  
  def show
    @course = Course.find(params[:id])
    @uploads = @course.uploads.sort_by &:year
    @years1 = @uploads.reverse.map(&:year).uniq
    @years = []
    @years1.each do |y|
      @years << y.year
    end
    @years = @years.uniq
    
    
  end
  
  def search
    @course = Course.find_by_full_name(params[:course_name])
    if !@course.nil?
      redirect_to @course
    else
      flash[:error] = "That course does not exist in your school databse yet.  You can add it by uploading a file to that course"
      redirect_to root_path
    end
  end
  
end