class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email,              :null => true, :default => ""
      t.string :full_name,          :null => true, :default => ""
      t.string :uid,                :null => false, :default => ""
      t.string :provider,           :null => false, :default => ""
      t.timestamps
    end
  end
end
