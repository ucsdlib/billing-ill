class CreateInvoice < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :charge_cents
      t.integer :number_prints
      t.string :type
      t.string :status
      t.text :ill_numbers
      t.datetime :submitted_at
      t.timestamps
      t.integer :patron_id
    end
  end
end
