class AddIllNumberToInvoice < ActiveRecord::Migration
  def change
    add_column(:invoices, :ill_number, :string)
  end
end
