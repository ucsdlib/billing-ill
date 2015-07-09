class RenameToCommentsToInvoice < ActiveRecord::Migration
  def change
    rename_column :invoices, :ill_numbers, :comments
  end
end
