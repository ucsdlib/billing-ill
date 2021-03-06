# encoding: utf-8
#---
# @author hweng@ucsd.edu
#---

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?, :convert_date_mmddyy

  def all_items(ref_model)
    result_arr = ref_model.order(:created_at)
    result_arr.page(params[:page]) if result_arr.present?
  end

  def country_list; end

  def convert_date_mmddyy(cdate)
    cdate.strftime('%m/%d/%y')
  end

  def current_user
    @current_user ||= User.find_by uid: session[:user_id] if session[:user_id]
  end

  def logged_in?
    !current_user.nil?
  end

  def require_user
    redirect_to signin_path, notice: 'You need to sign in!' unless logged_in?
  end

  def batch_update_status_field(ref_model)
    batch_update_status_item(ref_model)
  rescue ActiveRecord::RecordInvalid
    flash[:error] = 'Invalid record'
  end

  def batch_update_status_item(ref_model)
    result_arr = ref_model.search_all_pending_status

    ActiveRecord::Base.transaction do
      result_arr.each do |ref_row|
        ref_row.update_attributes!(status: 'submitted', submitted_at: Time.zone.now)
      end
    end
  end
end
