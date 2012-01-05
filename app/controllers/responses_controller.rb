class ResponsesController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  
  def create
    @response = current_user.responses.build(params[:response])
    if @response.save
      @upload = current_user.uploads.build(params[:upload])
      @upload.linked = @response.linked
      @upload.description = @response.description
		  @upload.school_id = @response.request.school.id
		  @upload.year = @response.request.year
		  @upload.semester = @response.request.semester
		  @upload.professor = @response.request.professor
		  @upload.temp_coursename = @response.request.course.full_name
		  @upload.stars = 0
		  @upload.ratings = 0
		  
      if @upload.save(false)
        #this is good, do nothing
      end
      
      
      flash[:success] = "Success!  The poster has been notified of your response"
      
      #notify the request poster
      UserMailer.response_notify(@response).deliver
      
      redirect_to request_responses_path(@response.request)
    else
      #TODO change this to be better
      flash[:error] = 'Sorry, there was an error posting your response, make sure you chose a valid file and
                        that you provided a description'
      redirect_to request_responses_path(Request.find(params[:response][:request_id]))
    end
  end
  
  def index
    if !signed_in?
      flash[:error] = "Sorry, you must be signed in to view your requests.  Sign in 
                        and then click on the link in your email again."
      redirect_to signin_path
    end
    @response = Response.new
    @upload = Upload.new
    @request = Request.find(params[:request_id])
    @responses = @request.responses
  end
  
  def destroy
    @response = current_user.responses.find_by_id(params[:id])
    @response.destroy if !@response.nil?
    redirect_to current_user
  end
  
  def download
    @response = Response.find(params[:id])
    redirect_to @response.linked.url
  end
  
  def accept
    UserMailer.accept_response(@response).deliver
    
    @response = Response.find(params[:id])
    @response.request.user.return_deposit
    @response.user.response_accepted
    @response.request.destroy
     
    flash[:notice] = "Your deposit has been returned and your request listing removed."
    redirect_to current_user
  end
end