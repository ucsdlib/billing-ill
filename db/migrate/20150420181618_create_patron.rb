class CreatePatron < ActiveRecord::Migration
  def change
    create_table :patrons do |t|
      t.string :email_address, :name, :ar_code
      t.string :address1, :address2, :address3, :address4 
      t.string :city, :state, :zip1, :zip2, :country_code
      t.timestamps
    end
  end
end
