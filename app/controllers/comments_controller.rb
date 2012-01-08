class CommentsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  
  def create
    @comment = current_user.comments.build(params[:comment])
    if @comment.save
      flash[:success] = "Thanks for your comment!"
      @comment.user.add_swag(50)
      @comment.file.user.add_swag(10)
      redirect_to upload_path(@comment.file, :swag => "50")
    else
      #TODO change this to be better
      flash[:error] = 'Comment Unsuccessful'
      redirect_to root_path
    end
  end
  
  def destroy
    @comment = current_user.comments.find_by_id(params[:id])
    @comment.destroy if !@comment.nil?
    redirect_to user_path(current_user, {:swag => "-50"})
  end
  
end