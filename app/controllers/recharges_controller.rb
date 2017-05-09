# encoding: utf-8
#---
# @author hweng@ucsd.edu
#---

require 'net/sftp'
require 'open-uri'

class RechargesController < ApplicationController
  before_action :require_user
  before_action :set_recharge, only: [:edit, :update]
  before_action :set_index_list, only: [:new, :create, :edit, :update]

  def index
    @total_count = Recharge.count
    @recharges = all_items(Recharge)
  end

  def new
    @recharge = Recharge.new
  end

  def create
    @recharge = Recharge.new(recharge_params)

    if @recharge.save
      redirect_to new_recharge_path, notice: 'A new recharge is created!'
    else
      render :new
    end
  end

  def edit
    @selected_index = @recharge.fund_id
    @selected_status = @recharge.status
  end

  def update
    if @recharge.update(recharge_params)
      flash[:notice] = 'Your recharge was updated'
      redirect_to new_recharge_path
    else
      render :edit
    end
  end

  def destroy
    recharge = Recharge.find(params[:id])
    recharge.destroy
    redirect_to recharges_path
  end

  def search
    result_arr = Recharge.search_by_index_code(params[:search_term])
    @search_result = result_arr.page(params[:page]) if result_arr.present?
    @search_count = result_arr.count
  end

  def process_batch
    @current_batch_count = Recharge.pending_status_count
    result_arr = Recharge.search_all_pending_status
    @current_batch_result = result_arr.page(params[:page]) if result_arr.present?
  end

  def create_output
    content = Recharge.process_output
    render plain: content
  end

  def ftp_file
    email_date = convert_date_mmddyy(Time.zone.now)
    Recharge.send_file
    AppMailer.send_recharge_email(current_user, email_date).deliver_now
    batch_update_status

    flash[:notice] = 'Your recharge file is uploaded to the campus server, and the email has been sent to ACT.'

    redirect_to recharges_path
  end

  private

  def batch_update_status
    batch_update_status_field(Recharge)
  end

  def recharge_params
    params.require(:recharge).permit(:number_copies, :charge, :status, :notes, :fund_id)
  end

  def set_recharge
    @recharge = Recharge.find params[:id]
  end

  def set_index_list
    @index_list = Fund.order('index_code').map { |fund| [fund.index_code, fund.id] }
  end
end
