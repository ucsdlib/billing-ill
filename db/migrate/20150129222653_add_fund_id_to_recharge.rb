class AddFundIdToRecharge < ActiveRecord::Migration
  def change
    add_column(:recharges, :fund_id, :integer)
  end
end

