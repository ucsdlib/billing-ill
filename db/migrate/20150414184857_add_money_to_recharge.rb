class AddMoneyToRecharge < ActiveRecord::Migration
  def change
    remove_column :recharges, :charge
    add_column :recharges, :charge_cents, :integer
  end
end
