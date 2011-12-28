class DownloadsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  
  def create
    @download = current_user.downloads.build(params[:download])
    if @download.save
      flash[:success] = "Downloading Now"
      redirect_to root_path
    else
      #TODO change this to be better
      flash[:error] = 'Download Unsuccessful'
      redirect_to root_path
    end
  end
  
  def destroy
    @download = current_user.downloads.find_by_id(params[:id])
    @download.destroy if !@download.nil?
    redirect_to current_user
  end
  
end