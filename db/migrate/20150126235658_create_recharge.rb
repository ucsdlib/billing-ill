class CreateRecharge < ActiveRecord::Migration
  def change
    create_table :recharges do |t|
      t.decimal :charge, :precision => 8, :scale => 2
      t.integer :number_copies
      t.string :status
      t.text :notes
      t.datetime :submitted_at
      t.timestamps
    end
  end
end
