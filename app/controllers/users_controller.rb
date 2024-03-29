class UsersController < ApplicationController
  include SessionsHelper
  
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  
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

        #Auto-confirm users in development                  
        if ENV['RAILS_ENV'] == "development"
          @user.confirm
        end
        
        UserMailer.welcome_email(@user).deliver
        
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
    @requests = @user.requests.all
    if params[:token]
      if params[:token] == secure_hash(@user.username)
        flash[:success] = "Account Confirmed. Please sign in to continue"
        redirect_to signin_path
        @user.confirm
      else
        flash[:error] = "An error occurred during account confirmation."
        redirect_to root_path
      end
    else
      if !signed_in?
        flash[:notice] = "You need to sign in to do that"
        redirect_to signin_path
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
    if @user.save(:validate => false)
      flash[:success] = "Five more credits added!"
    else
      flash[:error] = "Sorry, buying credits failed"
    end
    redirect_to root_path
  end
  
  #======================================================
  private
  #======================================================


      def correct_user
          user = User.find(params[:id])
          right_user = (current_user.id == user.id) unless current_user.nil?
          if (right_user == false)
            flash[:error] = "Sorry, you don't have permission to do that"
          end
          redirect_to(root_path) unless (right_user == true)
      end
      
      def admin_user
          redirect_to(root_path) unless current_user.admin?
      end
  
end
