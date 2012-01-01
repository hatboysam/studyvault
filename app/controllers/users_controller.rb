class UsersController < ApplicationController
  include SessionsHelper
  
  def new
    if signed_in?
      flash[:notice] = "You already have a StudyHeist account"
      redirect_to current_user
    else   
      @user = User.new
    end
  end
  
  def create
      @user = User.new(params[:user])
      if @user.save
        flash[:notice] = "Welcome to StudyHeist!  
                          Before you can log in, 
                          you must click the confirmation link in 
                          your email inbox."
        UserMailer.welcome_email(@user).deliver
        #NEED TO MAKE IT SO THEY CAN'T SIGN IN UNLESS CONFIRMED
        sign_in?(@user)
        redirect_to root_path
      else
        flash.now[:error] = "Sorry, there was an error creating your account"
        render 'new'
      end
  end
  
  def show
    @user = User.find(params[:id])
    @uploads = @user.uploads.all
    @downloads = @user.downloads.all
    if params[:token]
      if params[:token] == secure_hash(@user.username)
        flash.now[:success] = "Account Confirmed.  Welcome to StudyHeist!"
        @user.confirm
      else
        flash.now[:error] = "An error occurred during account confirmation."
      end
    end
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
