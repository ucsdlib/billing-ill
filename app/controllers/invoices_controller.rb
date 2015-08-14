#---
# @author hweng@ucsd.edu
#---

class InvoicesController < ApplicationController
  before_filter :require_user
  before_action :set_invoice, only: [:edit, :update, :create_bill]
  before_action :set_patron_list, only: [:new, :create, :edit, :update]
  before_action :set_current_batch, only: [:process_batch, :create_report]
 
  def index
    @total_count = Invoice.count
    @invoices = get_all_items(Invoice)
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

  def destroy
    invoice = Invoice.find(params[:id])
    invoice.destroy 
    redirect_to invoices_path
  end

  def search
    result_arr = []
    
    if params[:search_option]== "patron_name"
      result_arr = Invoice.search_by_patron_name(params[:search_term])
    elsif params[:search_option]== "invoice_num"
      result_arr = Invoice.search_by_invoice_num(params[:search_term])
    else
      result_arr = Invoice.search_by_invoice_num(params[:search_term])
    end

    @search_result = result_arr.page(params[:page]) if !result_arr.blank?
    @search_count = result_arr.count
  end

  def create_report
  end

  def process_batch
  end

  def create_bill
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "invoice",
               template: "invoices/create_bill.html.haml",
               layout: 'pdf',
               show_as_html: params[:debug].present? # renders html version if you set debug=true in URL
               #:save_to_file => Rails.root.join('pdfs', 'invoice.pdf')
      end
    end
  end

  def create_charge_output
    content = Invoice.get_charge_output
    render plain: content
  end

  def create_person_output
    content = Invoice.get_person_output
    render plain: content
  end

  def create_entity_output
    content = Invoice.get_entity_output
    render plain: content
  end

  def ftp_file
    charge_file = Invoice.create_charge_file
    entity_file = Invoice.create_entity_file
    person_file = Invoice.create_person_file
    file_name = {charge: charge_file, entity: entity_file, person: person_file}
    lfile_name = {charge: Invoice.get_charge_lfile_name, entity: Invoice.get_entity_lfile_name, person: Invoice.get_person_lfile_name}

    send_file(file_name)
    send_email(file_name,lfile_name)

    flash[:notice] = "Your CHARGE, ENTITY and PERSON files are uploaded to the campus server, and the email has been sent to ACT."

    redirect_to invoices_path
  end

  def merge_records
     batch_update_status_field(Invoice)

     flash[:notice] = "The current batch records have been merged."
     redirect_to invoices_path
  end
  
  private

  def send_email(file_name,lfile_name)
    record_count = {
                    charge: Invoice.search_all_pending_status.size + 2, 
                    entity: Invoice.get_entity_count + 2, 
                    person: Invoice.get_person_count + 2
                   }
    
    email_date = convert_date_mmddyy(Time.now)
    AppMailer.send_invoice_email(current_user, email_date, file_name, lfile_name, record_count).deliver_now
  end

  def send_file(file_name)
    
    local_charge_file_path = "tmp/ftp/" + file_name[:charge]
    remote_charge_file_path = Rails.application.secrets.sftp_folder + "/" + file_name[:charge]
    local_entity_file_path = "tmp/ftp/" + file_name[:entity]
    remote_entity_file_path = Rails.application.secrets.sftp_folder + "/" + file_name[:entity]
    local_person_file_path = "tmp/ftp/" + file_name[:person]
    remote_person_file_path = Rails.application.secrets.sftp_folder + "/" + file_name[:person]

    server_name = Rails.application.secrets.sftp_server_name
    user = Rails.application.secrets.sftp_user
    password = Rails.application.secrets.sftp_password

    Rails.logger.info("Creating SFTP connection")
    session=Net::SSH.start(server_name, user, :password=> password)
    sftp=Net::SFTP::Session.new(session).connect!
    Rails.logger.info("SFTP Connection created, uploading files.")
    sftp.upload!(local_charge_file_path, remote_charge_file_path)
    sftp.upload!(local_entity_file_path, remote_entity_file_path)
    sftp.upload!(local_person_file_path, remote_person_file_path)
    Rails.logger.info("File uploaded, Connection terminated.")
  end

  def invoice_params
    params.require(:invoice).permit(:invoice_num, :number_prints, :comments, :ill_number, :charge, :status, :invoice_type, :patron_id)
  end

  def set_invoice
    @invoice = Invoice.find params[:id]
  end

  def set_patron_list
    @patron_list = Patron.order("name").map{|patron|[patron.name,patron.id]}
  end

  def set_current_batch
    @current_batch_count = Invoice.pending_status_count
    result_arr = Invoice.search_all_pending_status
    @current_batch_result = result_arr.page(params[:page]) if !result_arr.blank?
  end
end