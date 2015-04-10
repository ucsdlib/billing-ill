#---
# by hweng@ucsd.edu
#---
require 'net/sftp'
require 'open-uri'

class RechargesController < ApplicationController
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
      redirect_to root_path, notice: 'A new recharge is created!'
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
      redirect_to root_path
    else
      render :edit
    end
  end

  def search
      @total_count = Recharge.count
      result_arr = Recharge.search_by_index_code(params[:search_term])
      @search_result = result_arr.page(params[:page]) if !result_arr.blank?
  end

  def process_batch
    @current_batch_count = Recharge.pending_status_count
    result_arr = Recharge.search_all_pending_status
    @current_batch_result = result_arr.page(params[:page]) if !result_arr.blank?
  end

  def process_output
    result_arr = Recharge.search_all_pending_status
    
    # header rows
    h_column1_19 = "LIBRARY1" + "01" + "FRLBG551" + "1"
    h_column20_54 = "LIBRARY RECHARGES"+ " " * 18
    
    transaction_date = convert_date_yyyymmdd(Time.now)
    h_column75_250 = "N" + " " * 175

    # detail_rows
    d_column1_19 = "LIBRARY1" + "01" + "FRLBG551" + "2"
    d_column24_27 = "F510"
    d_column40_76 = "LIBRARY-PHOTOCOPY SERVICE" + " " * 10 + "D" + "A"
    d_column89_94 = "636064"
    d_column101_112 = " " * 6 + " " * 6
    d_column123_209 = " " * 32 + "000000" + " " * 17 + "000000" + " " * 10 + "0000" + "0000" + " " * 9
    d_column220 = " "

    detail_rows = ""
    total_charge = 0
    result_arr.each_with_index do |recharge, index|
      sequence_num = convert_seq_num(index)
      charge = recharge.charge
      transaction_amount = convert_charge(charge)
      fund_code = recharge.fund_fund_code
      org_code = recharge.fund_org_code
      program_code = recharge.fund_program_code
      index_code = recharge.fund_index_code
      filler_var = convert_date_yyyymmdd(recharge.created_at) + " " * 2
      total_charge += charge

      detail_rows += "#{d_column1_19}#{sequence_num}#{d_column24_27}#{transaction_amount}#{d_column40_76}#{fund_code}#{org_code}"
      detail_rows += "#{d_column89_94}#{program_code}#{d_column101_112}#{index_code}#{d_column123_209}#{filler_var}#{d_column220}\n"
    end
    
    #final credit row
    f_column1_19 = "LIBRARY1" + "01" + "FRLBG551" + "2"
    f_sequence_num = convert_seq_num(result_arr.size + 1)
    f_column24_27 = "F510"
    total_amount = convert_charge(total_charge)
    f_column40_76 = "LIBRARY-PHOTOCOPY SERVICE" + " " * 10 + "C" + "A"
    f_column77_112 = " " * 12 + "693900" + " " * 18
    f_column113_122 = "LIBIL05" + " " * 3
    f_column123_154 = " " * 29
    f_column155_209 = "000000" + " " * 17 + "000000" + " " * 10 + "0000" + "0000" + " " * 9
    f_filler_var = convert_date_yyyymmdd(Time.now) + " " * 2 
    f_column220 = " "

    document_amount = convert_charge(total_charge * 2)

    header_row = "#{h_column1_19}#{h_column20_54}#{transaction_date}#{document_amount}#{h_column75_250}\n"
    
    final_rows = "#{f_column1_19}#{f_sequence_num}#{f_column24_27}#{total_amount}#{f_column40_76}"
    final_rows += "#{f_column77_112}#{f_column113_122}#{f_column123_154}#{f_column155_209}#{f_filler_var}#{f_column220}"

    content = "#{header_row}#{detail_rows}#{final_rows}"
  end

  def create_output
    content = process_output
    render plain: content
  end

  def create_file
    file_name = "FISP.JVDATA.D" + convert_date_yymmdd(Time.now) + ".LIB"
    path = "tmp/ftp/" + file_name
    content = process_output
    #puts Dir.pwd
    
    File.open(path, "w") do |f|
      f.write(content)
    end

    return file_name
  end

  def ftp_file
    file_name = create_file
    
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

    batch_update_status
    
    flash[:notice] = "Your recharge file is FTP to the campus"

    redirect_to recharges_path
  end

  def batch_update_status
    begin
      batch_update_status_item
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid record"
    end
  end

  private

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
    @index_list = Fund.all.map{|fund|[fund.index_code,fund.id]}
  end
end