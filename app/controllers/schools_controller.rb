class SchoolsController < ApplicationController
  def index
    if params[:term]
      if ENV['RAILS_ENV'] == "development"
        @schools = School.find(:all, :conditions => ['name LIKE ?', "#{params[:term]}%"])
      else 
        @schools = School.find(:all, :conditions => ['name ILIKE ?', "#{params[:term]}%"])
      end
    else
      @schools = School.all
    end
    
    @school_names = @schools.map(&:name).first(10)
    
    respond_to do |format|
      format.html
      format.js
      format.json do
        @schools.map! do |u|
          {
            :label => u.name,
            :value => u.id
          }
        end
        render :json => @schools
      end
    end
  end
  
  def show
    @school = School.find(params[:id])
    @courses = @school.courses.all.sort_by &:full_name
    @subjects = @courses.map(&:subject).uniq
  end
  
  def search
    @school = School.find_by_name(params[:school_name])
    if !@school.nil?
      redirect_to @school
    else
      flash[:error] = "That school does not exist in our database.  Make sure you are using the proper name of your University, for example: Pennsylvania State not Penn State"
      redirect_to root_path
    end
  end
end