class UploadsController < ApplicationController
  before_filter :authenticate
  
  def create
    @upload = current_user.uploads.build(params[:upload])
    if @upload.save
      flash[:success] = "Upload Successful (#{@upload.linked.original_filename})"
      @upload.user.add_swag(200)
      redirect_to root_path(nil, :swag => "200")
    else
      #TODO change this to be better
      flash.now[:error] = 'Sorry, there was an error with your upload, make sure all fields are filled correctly.'
      render 'pages/index'
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
    @downloads = @upload.downloads.all 
  end
  
  def download
    @upload = Upload.find(params[:id])
    if (current_user.credits > 0)
      if (!current_user.has_downloaded?(@upload)) && !(current_user == @upload.user) #if they haven't already downloaded it
        @download = current_user.downloads.build(:upload_id => @upload.id)
        if @download.save 
          #if we can record the download
          current_user.add_swag(50)
          @upload.user.add_swag(20)
          current_user.charge
          current_user.add_download
          
            if (12.hours < (DateTime.now.to_f - current_user.last_download_email.to_f))
              UserMailer.download_email(current_user).deliver
              current_user.reset_downloads
            end
          
          redirect_to @upload.linked.url
        else 
          #couldn't record the download, not doing anything here
        end
      else 
        #they have already downloaded it
        redirect_to @upload.linked.url
      end
    else
      flash[:notice] = "You need credits to download, buy them here or upload content to receieve free credits."
      redirect_to new_purchase_path
    end
  end
end