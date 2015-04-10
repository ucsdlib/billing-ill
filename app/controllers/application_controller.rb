#---
# by hweng@ucsd.edu
#---

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  def convert_seq_num (seq_num)
    str = seq_num.to_s.rjust(4, "0") # 1 --> 0001, 10 --> 0010
  end

  def convert_charge(amount)
    s_amount = (100* amount).round.to_s  # 0.50 --> "50"
    output_amount = "0" *(12 - s_amount.length) + s_amount
  end

  def convert_date_yyyymmdd(cdate)
    cdate.strftime("%Y%m%d")
  end

  def convert_date_yymmdd(cdate)
    cdate.strftime("%y%m%d")
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
