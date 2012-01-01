class SessionsController < ApplicationController

  def new
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
        redirect_to user
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