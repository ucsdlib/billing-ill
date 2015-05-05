class AddInvoiceNumToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :invoice_num, :string
  end
end
