class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def convert_seq_num (seq_num)
    str = seq_num.to_s.rjust(4, "0") # 1 --> 0001, 10 --> 0010
  end

  def convert_charge(amount)
    s_amount = (100* amount).round.to_s  # 0.50 --> "50"
    output_amount = "0" *(12 - s_amount.length) + s_amount
  end

  def convert_date(cdate)
    cdate.strftime("%Y%m%d")
  end

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
