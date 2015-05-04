#---
# by hweng@ucsd.edu
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

  private

  def invoice_params
    params.require(:invoice).permit(:number_prints, :ill_numbers, :charge, :status, :invoice_type, :patron_id)
  end

  def set_invoice
    @invoice = Invoice.find params[:id]
  end

  def set_patron_list
    @patron_list = Patron.order("name").map{|patron|[patron.name,patron.id]}
  end
end