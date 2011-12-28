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
      flash[:info] = "Welcome Back!"
      sign_in user
      redirect_to user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end