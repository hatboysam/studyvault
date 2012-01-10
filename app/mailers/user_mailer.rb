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
  
  def response_notify(response)
    @response = response
    @request = @response.request
    @user = @response.request.user
    @url = "http://www.studyheist.com/requests/#{@request.id}/responses"
    
    mail(:to => "#{@user.username} <#{@user.email}>",
         :subject => "Your StudyHeist Marketplace request got a response!")
  end
  
  def accept_response(response)
    @response = response
    @user = @response.user
    
    mail(:to => "#{@user.username} <#{@user.email}>",
         :subject => "Your StudyHeist Marketplace response was accepted!")
  end
  
  def download_email(user)
    @user = user
    @downloads = @user.downloads.reject{|x| @user.has_commented? x.upload}
    @number = @downloads.length
    
    mail(:to => "#{@user.username} <#{@user.email}>",
         :subject => "You have #{@number} new downloads to rate on StudyHeist - #{DateTime.now.strftime("%B %d, %Y")
}")
         
  end
  
end
