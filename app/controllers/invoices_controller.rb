#---
# @author hweng@ucsd.edu
#---

class InvoicesController < ApplicationController
  before_filter :require_user
  before_action :set_invoice, only: [:edit, :update]
  before_action :set_patron_list, only: [:new, :create, :edit, :update]
 
  def index
    @total_count = Invoice.count
    result_arr = Invoice.order(:created_at)
    @invoices = result_arr.page(params[:page]) if !result_arr.blank?
  end

  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new(invoice_params)

    if @invoice.save
      redirect_to new_invoice_path, notice: 'A new invoice is created!'
    else
      render :new
    end
  end

  def edit
    @selected_patron = @invoice.patron_id
    @selected_status = @invoice.status
    @selected_type = @invoice.invoice_type
  end

  def update
    
    if @invoice.update(invoice_params)
      flash[:notice] = "Your invoice was updated"
      redirect_to new_invoice_path
    else
      render :edit
    end
  end

  def search
    result_arr = []
    
    if params[:search_option]== "patron_name"
      result_arr = Invoice.search_by_patron_name(params[:search_term])
    elsif params[:search_option]== "invoice_num"
      result_arr = Invoice.search_by_invoice_num(params[:search_term])
    end

    @search_result = result_arr.page(params[:page]) if !result_arr.blank?
    @search_count = result_arr.count
  end

  def process_batch
    @current_batch_count = Invoice.pending_status_count
    result_arr = Invoice.search_all_pending_status
    @current_batch_result = result_arr.page(params[:page]) if !result_arr.blank?
  end

  def process_charge_output
    result_arr = Invoice.search_all_pending_status

    # header rows
    h_column1_21 = "CHDR" + " " * 1 + "CLIBRARY.CHARGE" + " " * 1
    transaction_date = Time.now.strftime("%m%d%y")
    h_column28 = " " * 1
    h_column35_320 = " " * 1 + "000001" + " " * 279
    
    # detail_rows
    d_column1 = "A"
    d_column11_51 = " " * 35 + "LIBLPS"
    d_column63_68 = " " * 6
    d_column79_320 = " " * 240

    detail_rows = ""
    total_charge = 0
    result_arr.each_with_index do |invoice, index|
      charge = invoice.charge
      charge_amount = convert_invoice_charge(charge)
      document_num = convert_invoice_num(invoice.invoice_num)
      account_id = invoice.patron_ar_code

      total_charge += charge

      detail_rows += "#{d_column1}#{account_id}#{d_column11_51}#{charge_amount}#{d_column63_68}#{document_num}#{d_column79_320}\n"
    end

    # trailer row
    t_column1_5 = "CTRL" + " " * 1
    t_column12 = " "
    t_column24_320 = " " * 297
    record_count = convert_record_count(result_arr.size + 2)
    total_amount = convert_invoice_charge(total_charge)

    header_row = "#{h_column1_21}#{transaction_date}#{h_column28}#{transaction_date}#{h_column35_320}\n"

    final_rows = "#{t_column1_5}#{record_count}#{t_column12}#{total_amount}#{t_column24_320}"
    content = "#{header_row}#{detail_rows}#{final_rows}"
  end

  def process_person_output
    result_arr = Invoice.search_all_pending_status

    # header rows
    h_column1_21 = "PHDR" + " " * 1 + "CLIBRARY.PERSON" + " " * 1
    transaction_date = Time.now.strftime("%m%d%y")
    h_column28 = " " * 1
    h_column35_320 = " " * 1 + "000001" + " " * 279

    # detail_rows
    d_column1_10 = "C" + " " * 9
    d_column20_23 = " " * 4
    d_column114_119 = " " * 6
    d_column291_320 = " " * 29

    detail_rows = ""
    result_arr.each_with_index do |invoice, index|
      person_id = invoice.patron_ar_code
      name_key = convert_name_key(invoice.patron_name)
      full_name = convert_full_name(invoice.patron_name)
      address1 = convert_address1(invoice.patron_address1)
      address2 = convert_address2(invoice.patron_address2)
      address3 = convert_address2(invoice.patron_address3)
      address4 = convert_address2(invoice.patron_address4)
      city = convert_city(invoice.patron_city)
      state = invoice.patron_state
      zip1 = invoice.patron_zip1
      zip2 = convert_zip2(invoice.patron_zip2)
      country_code = convert_country(invoice.patron_country_code)

      detail_rows += "#{d_column1_10}#{person_id}#{d_column20_23}#{name_key}#{full_name}#{d_column114_119}"
      detail_rows += "#{address1}#{address2}#{address3}#{address4}#{city}#{state}#{zip1}#{zip2}#{country_code}\n"
    end

    # trailer row
    t_column1_5 = "PTRL" + " " * 1
    t_column12_320 = " " * 309
    record_count = convert_record_count(result_arr.size + 2)

    header_row = "#{h_column1_21}#{transaction_date}#{h_column28}#{transaction_date}#{h_column35_320}\n"

    final_rows = "#{t_column1_5}#{record_count}#{t_column12_320}"
    content = "#{header_row}#{detail_rows}#{final_rows}"
  end

  def create_charge_output
    content = process_charge_output
    render plain: content
  end

  def create_person_output
    content = process_person_output
    render plain: content
  end

  def ftp_file
    file_name = create_charge_file

    flash[:notice] = "Your recharge file is uploaded to the campus server, and the email has been sent to ACT."

    redirect_to invoices_path
  end

  private
  def create_entity_file
    file_name = "ENTITY.D14289"
    path = "tmp/ftp/" + file_name
    content = process_entity_output
    
    write_file(path,content )

    return file_name
  end

  def create_person_file
    file_name = "PERSON.D14289"
    path = "tmp/ftp/" + file_name
    content = process_person_output

    write_file(path,content )

    return file_name
  end

  def create_charge_file
    file_name = "CHARGE.D14289"
    path = "tmp/ftp/" + file_name
    content = process_charge_output

    write_file(path,content )

    return file_name
  end

  def write_file(path,content )
    File.open(path, "w") do |f|
      f.write(content)
    end
  end

  def convert_invoice_charge(amount)
    s_amount = (10* amount).to_f.round.to_s  # 0.50 --> "50"
    output_amount = "0" *(10 - s_amount.length) + s_amount + "{"
  end

  def convert_invoice_num(invoice_num)
    str = invoice_num.to_s.rjust(10, " ") 
  end

  def convert_record_count(record_count)
    str = record_count.to_s.rjust(6, "0")
  end

  def convert_name_key(input)
    output = " " *(35 - input.length) + input
  end

  def convert_full_name(input)
    output = " " *(55 - input.length) + input
  end

  def convert_address1(input)
    output = " " *(35 - input.length) + input
  end

  def convert_address2(input)
    output = " " *(35 - input.length) + input
  end

  def convert_city(input)
    output = " " *(18 - input.length) + input
  end

  def convert_zip2(input)
    output = " " *(4 - input.length) + input
  end

  def convert_country(input)
    output = " " *(2 - input.length) + input
  end

  def invoice_params
    params.require(:invoice).permit(:invoice_num, :number_prints, :ill_numbers, :charge, :status, :invoice_type, :patron_id)
  end

  def set_invoice
    @invoice = Invoice.find params[:id]
  end

  def set_patron_list
    @patron_list = Patron.order("name").map{|patron|[patron.name,patron.id]}
  end
end