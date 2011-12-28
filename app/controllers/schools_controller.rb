class SchoolsController < ApplicationController
  def index
    if params[:search]
      @schools = School.find(:all, :conditions => ['name LIKE?', "%#{params[:search]}%"])
    else
      @schools = School.all
    end
    
    respond_to do |format|
      format.html
      format.js
    end
  end
end