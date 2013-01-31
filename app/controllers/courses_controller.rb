class CoursesController < ApplicationController
  include CourseNameHelper
  
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
    
    @suggestions = suggestions_list(params[:term])
    @courses = @courses.map(&:full_name) + @suggestions
    @course_names = @courses.each_with_index.map{|x,i| {id: i, value: x}}
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def show
    @course = Course.find(params[:id])
    @uploads = @course.uploads.sort_by &:year
    @course_year_objects = @uploads.reverse.map(&:year).uniq
    @years = @course_year_objects.map{|x| x.year}.uniq
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