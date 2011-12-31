class UsersController < ApplicationController
  
  def new 
    @user = User.new
  end
  
  def create
      @user = User.new(params[:user])
      if @user.save
        flash[:success] = "Welcome to StudyHeist!"
        sign_in @user
        redirect_to @user
      else
        flash.now[:error] = "Sorry, there was an error creating your account"
        render 'new'
      end
  end
  
  def show
    @user = User.find(params[:id])
    @uploads = @user.uploads.all
    @downloads = @user.downloads.all
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(params[:user])
      redirect_to @user
    else
      render :action => "edit"
    end
  end
  
  def add
    @user = User.find(params[:id])
    @user.add_credits(5)
    if @user.save(false)
      flash[:success] = "Five more credits added!"
    else
      flash[:error] = "Sorry, buying credits failed"
    end
    redirect_to root_path
  end
  
end
