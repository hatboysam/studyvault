class SessionsController < ApplicationController

  def new
    if signed_in?
      flash[:error] = "You are alredy signed in, sign out if you want to sign in to a different account."
      redirect_to current_user
    end
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    
    if user.nil?
      flash[:error] = "Signin Failed"
      render 'new'
      #work on error messages
    else
      if sign_in?(user)
        flash[:info] = "Welcome Back!"
        redirect_back_or user
      else
        flash.now[:error] = "You must confirm your email before you may sign in,
                              please click the link in your inbox."
                              
        render 'new'
      end
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end