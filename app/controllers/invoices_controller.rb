# encoding: utf-8
#---
# @author hweng@ucsd.edu
#---

class InvoicesController < ApplicationController
  before_action :require_user
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
      flash[:notice] = 'Your invoice was updated'
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

    if params[:search_option] == 'patron_name'
      result_arr = Invoice.search_by_patron_name(params[:search_term])
    elsif params[:search_option] == 'invoice_num'
      result_arr = Invoice.search_by_invoice_num(params[:search_term])
    else
      result_arr = Invoice.search_by_invoice_num(params[:search_term])
    end

    @search_result = result_arr.page(params[:page]) unless result_arr.blank?
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
        render pdf: 'invoice',
               template: 'invoices/create_bill.html.haml',
               layout: 'pdf',
               show_as_html: params[:debug].present? # renders html version if you set debug=true in URL
        #:save_to_file => Rails.root.join('pdfs', 'invoice.pdf')
      end
    end
  end

  def create_charge_output
    content = Invoice.charge_output
    render plain: content
  end

  def create_person_output
    content = Invoice.person_output
    render plain: content
  end

  def create_entity_output
    content = Invoice.entity_output
    render plain: content
  end

  def ftp_file
    email_date = convert_date_mmddyy(Time.now)

    Invoice.send_file
    AppMailer.send_invoice_email(current_user, email_date).deliver_now

    flash[:notice] = 'Your CHARGE, ENTITY and PERSON files are uploaded to the campus server, and the email has been sent to ACT.'

    redirect_to invoices_path
  end

  def merge_records
    batch_update_status_field(Invoice)

    flash[:notice] = 'The current batch records have been merged.'
    redirect_to invoices_path
  end

  private

  def invoice_params
    params.require(:invoice).permit(:invoice_num, :number_prints, :comments, :ill_number, :charge, :status, :invoice_type, :patron_id)
  end

  def set_invoice
    @invoice = Invoice.find params[:id]
  end

  def set_patron_list
    @patron_list = Patron.order('name').map { |patron| [patron.name, patron.id] }
  end

  def set_current_batch
    @current_batch_count = Invoice.pending_status_count
    result_arr = Invoice.search_all_pending_status
    @current_batch_result = result_arr.page(params[:page]) unless result_arr.blank?
  end
end
