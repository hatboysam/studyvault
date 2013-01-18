class ResponsesController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy, :index, :download, :accept]
  before_filter :correct_user, :only => [:accept, :download]
  
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
		  @response.user.add_swag(100)
		  
      if @upload.save(:validate => false)
        @upload.user.add_swag(200)
        @response.assign_upload(@upload)
      end
      
      
      flash[:success] = "Success!  The poster has been notified of your response"
      
      #notify the request poster
      UserMailer.response_notify(@response).deliver
      
      redirect_to request_responses_path(@response.request, :swag => "300")
    else
      #TODO change this to be better
      flash[:error] = 'Sorry, there was an error posting your response, make sure you chose a valid file and
                        that you provided a description'
      redirect_to request_responses_path(Request.find(params[:response][:request_id]))
    end
  end
  
  def index
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
    @download = current_user.downloads.build(:upload_id => @response.upload.id)
    @download.save
    redirect_to @response.linked.url
  end
  
  def accept
    @response = Response.find(params[:id])
    
    @response.user.add_swag(150)
    
    UserMailer.accept_response(@response).deliver
  
    @response.request.user.return_deposit
    @response.user.response_accepted
    @response.request.destroy
     
    flash[:notice] = "Your deposit has been returned and your request listing removed."
    redirect_to current_user
  end
  
  #======================================================
  private
  #======================================================


      def correct_user
          @response = Response.find(params[:id])
          @request = @response.request
          if !(current_user.id == @request.user.id)
            flash[:error] = "Sorry, you don't have permission to do that"
            redirect_to(root_path)
          end
      end
end