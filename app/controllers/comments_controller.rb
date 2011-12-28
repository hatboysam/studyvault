class CommentsController < ApplicationController
  before_filter :authenticate, :only => [:create]
  
  def create
    @comment = current_user.comments.build(params[:comment])
    if @comment.save
      flash[:success] = "Thanks for your comment!"
      redirect_to @comment.file
    else
      #TODO change this to be better
      flash[:error] = 'Comment Unsuccessful'
      redirect_to root_path
    end
  end
  
  def destroy
    @comment = current_user.comments.find_by_id(params[:id])
    @comment.destroy if !@comment.nil?
    redirect_to current_user
  end
  
end