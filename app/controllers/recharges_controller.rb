#---
# @author hweng@ucsd.edu
#---

require 'net/sftp'
require 'open-uri'

class RechargesController < ApplicationController
  before_filter :require_user
  before_action :set_recharge, only: [:edit, :update]
  before_action :set_index_list, only: [:new, :create, :edit, :update]

  def index
    @total_count = Recharge.count
    result_arr = Recharge.order(:created_at)
    @recharges = result_arr.page(params[:page]) if !result_arr.blank?
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
      flash[:notice] = "Your recharge was updated"
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
      @search_result = result_arr.page(params[:page]) if !result_arr.blank?
      @search_count = result_arr.count
  end

  def process_batch
    @current_batch_count = Recharge.pending_status_count
    result_arr = Recharge.search_all_pending_status
    @current_batch_result = result_arr.page(params[:page]) if !result_arr.blank?
  end

  
  def create_output
    content = Recharge.process_output
    render plain: content
  end

  def ftp_file
    file_name = Recharge.create_file
    
    send_file(file_name)
    send_email(file_name)
    batch_update_status
    
    flash[:notice] = "Your recharge file is uploaded to the campus server, and the email has been sent to ACT."

    redirect_to recharges_path
  end

  private

  def send_file(file_name)
    local_file_path = "tmp/ftp/" + file_name
    remote_file_path = Rails.application.secrets.sftp_folder + "/" + file_name
    server_name = Rails.application.secrets.sftp_server_name
    user = Rails.application.secrets.sftp_user
    password = Rails.application.secrets.sftp_password

    Rails.logger.info("Creating SFTP connection")
    session=Net::SSH.start(server_name, user, :password=> password)
    sftp=Net::SFTP::Session.new(session).connect!
    Rails.logger.info("SFTP Connection created, uploading files.")
    sftp.upload!(local_file_path, remote_file_path)
    Rails.logger.info("File uploaded, Connection terminated.")
  end

  def send_email(file_name)
    record_count = Recharge.search_all_pending_status.size
    email_date = convert_date_mmddyy(Time.now)
    AppMailer.send_recharge_email(current_user, email_date, file_name, record_count).deliver_now
  end

  def batch_update_status
    begin
      batch_update_status_item
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid record"
    end
  end

  def batch_update_status_item
    result_arr = Recharge.search_all_pending_status

    ActiveRecord::Base.transaction do
      result_arr.each do |recharge|
        # add bang after update_attributes so that if it is not saved, it will raise error and roll back whole transaction.
        recharge.update_attributes!(status: "submitted") 
      end
    end
  end
  
  def recharge_params
    params.require(:recharge).permit(:number_copies, :charge, :status, :notes, :fund_id)
  end

  def set_recharge
    @recharge = Recharge.find params[:id]
  end

  def set_index_list
    @index_list = Fund.order("index_code").map{|fund|[fund.index_code,fund.id]}
  end
end