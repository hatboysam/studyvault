class RequestsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy, :show]
  before_filter :correct_school, :only => [:index]
  
  def create
    @user = User.find(params[:request][:user_id])
    if @user.credits > 1
      @request = current_user.requests.build(params[:request])
      if @request.save
        @request.user.make_request
        flash[:success] = "Request posting successful.  Deposit of 2 credits made."
        @request.user.add_swag(50)
        redirect_to school_requests_path(@request.school, :swag => "50")
      else
        #TODO change this to be better
        flash[:error] = 'Sorry, there was an error posting your request, make sure you filled out all fields
                          and your course name is of the format Subject 123'
        redirect_to school_requests_path(@user.school)
      end
    else
      flash[:error] = "You need at least two credits to make a request"
      redirect_to new_purchase_path
    end
  end
  
  def index
    @school = School.find(params[:school_id])
    @request = Request.new
    @requests = @school.requests
    @courses = @requests.map(&:course).uniq.sort_by(&:full_name)
    @subjects_to_courses = @courses.group_by(&:subject)
  end
  
  def destroy
    @request = current_user.requests.find_by_id(params[:id])
    @request.user.return_deposit
    @request.destroy if !@request.nil?
    redirect_to current_user
  end
  
  def show
  end
  
  #======================================================
  private
  #======================================================


      def correct_school
          @school = School.find(params[:school_id])
          if !(current_user.school.id == @school.id)
            flash[:error] = "Sorry, you don't have permission to do that"
            redirect_to(root_path)
          end
      end
  
end