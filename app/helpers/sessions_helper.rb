module SessionsHelper

  def sign_in?(user)
    if user.confirmed?
      cookies.permanent.signed[:remember_token] = [user.id, user.pepper]
      self.current_user = user
      return true
    else
      return false
    end
  end
  
  def current_user=(user)
      @current_user = user
  end
  
  def current_user
      @current_user ||= user_from_remember_token
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  def authenticate
      deny_access unless signed_in?
  end
  
  def deny_access
      store_location
      if flash[:notice].blank?
        flash[:notice] = "You need to sign in to do that"
      end
      redirect_to signin_path
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  def secure_hash(string)
      Digest::SHA2.hexdigest(string)
  end
  
  private

      def user_from_remember_token
        User.authenticate_with_pepper(*remember_token)
      end

      def remember_token
        cookies.signed[:remember_token] || [nil, nil]
      end
      
      def store_location
        session[:return_to] = request.fullpath
      end

      def clear_return_to
        session[:return_to] = nil
      end
  
end
