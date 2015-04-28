class InvoicesController < ApplicationController
  before_filter :require_user
  before_action :set_invoice, only: [:edit, :update]
  before_action :set_index_list, only: [:new, :create, :edit, :update]

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
    @selected_index = @invoice.patron_id
    @selected_status = @invoice.status
    @selected_type = @invoice.type
  end

  def update

    if @invoice.update(invoice_params)
      flash[:notice] = "Your invoice was updated"
      redirect_to new_invoice_path
    else
      render :edit
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:number_prints, :ill_numbers, :charge, :status, :type, :patron_id)
  end

  def set_invoice
    @invoice = Invoice.find params[:id]
  end

  def set_index_list
    @index_list = patron.order("name").map{|patron|[patron.name,patron.id]}
  end
end