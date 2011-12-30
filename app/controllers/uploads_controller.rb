class UploadsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy, :download]
  
  def create
    @upload = current_user.uploads.build(params[:upload])
    if @upload.save
      flash[:success] = "Upload Successful (#{@upload.linked.original_filename})"
      redirect_to root_path
    else
      #TODO change this to be better
      flash[:error] = 'Upload Unsuccessful'
      redirect_to root_path
    end
  end
  
  def destroy
    @upload = current_user.uploads.find_by_id(params[:id])
    @upload.destroy if !@upload.nil?
    redirect_to current_user
  end
  
  def show
    @comment = Comment.new
    @upload = Upload.find(params[:id])
    @comments = @upload.comments.all
    @comments2 = @upload.comments.find(:all, :conditions => {:user_id => current_user.id})
    @downloads = @upload.downloads.all
    @downloads2 = @upload.downloads.find(:all, :conditions => {:user_id => current_user.id})
  end
  
  def download
    @upload = Upload.find(params[:id])
    if (!current_user.has_downloaded?(@upload)) && !(current_user == @upload.user) #if they haven't already downloaded it
      @download = current_user.downloads.build(:upload_id => @upload.id)
      if @download.save #if we can record the download
        redirect_to @upload.linked.url
        flash.now[:notice] = "Download started, you have been charged one credit"
        current_user.charge
      else #couldn't record the download
        flash.now[:error] = "Sorry, there was an error downloading your file"
      end
    else #they have already downloaded it
      redirect_to @upload.linked.url
      flash.now[:notice] = "Re-Download started, you have not been charged"
    end
  end
end