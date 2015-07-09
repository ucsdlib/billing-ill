#---
# @author hweng@ucsd.edu
#---

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?, :convert_date_mmddyy

  def convert_date_mmddyy(cdate)
    cdate.strftime("%m/%d/%y")
  end
  
  def current_user
    @current_user ||= User.find_by uid: session[:user_id] if session[:user_id]
  end

  def logged_in?
    !!current_user 
  end

  def require_user
    redirect_to signin_path, notice: 'You need to sign in!' unless logged_in?
  end
end
