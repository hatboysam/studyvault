class UserMailer < ActionMailer::Base
  include SessionsHelper
  
  default :from => "accounts@studyheist.com"
  
  def welcome_email(user)
    @user = user
    @token = secure_hash(@user.username)
    @url = "http://www.studyheist.com/users/#{@user.id}?token=#{@token}"
    
    mail(:to => "#{user.username} <#{@user.email}>",
         :subject => "Thanks for joining StudyHeist!")
  end
  
  def purchase_receipt(purchase)
    @user = purchase.user
    @number = purchase.id
    
    mail(:to => "#{@user.username} <#{@user.email}>",
         :subject => "Thanks for your purchase at StudyHeist!")
  end
  
end
