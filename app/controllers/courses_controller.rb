class CoursesController < ApplicationController
  def index
    if params[:term]
      @split = params[:term].split(' ', 2)
      @subject = @split.first
      @code = @split.last
      if ENV['RAILS_ENV'] == "development"
        @courses = current_user.school.courses.find(:all, :conditions => ['full_name LIKE ? OR full_name LIKE ?', "%#{@subject}%", "%#{@code}%"])
      else
        @courses = current_user.school.courses.find(:all, :conditions => ['full_name ILIKE ? OR full_name ILIKE ?', "%#{@subject}%", "%#{@code}%"])
      end
    else
      @courses = Course.all
    end
    
    @course_names = @courses.map(&:full_name).first(10)
    
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
    @uploads = @course.uploads
  end
  
end