class UserMailer < ActionMailer::Base
  include SessionsHelper
  
  default :from => "accounts@studyheist.com"
  
  def welcome_email(user)
    @user = user
    @token = secure_hash(@user.username)
    @url = "http://www.studyheist.com/users/#{@user.id}?token=#{@token}"
    
    mail(:to => @user.email,
         :subject => "Thanks for joining StudyHeist!")
  end
  
end
