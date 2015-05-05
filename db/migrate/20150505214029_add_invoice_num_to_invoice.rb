class AddInvoiceNumToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :invoice_num, :integer
  end
end
