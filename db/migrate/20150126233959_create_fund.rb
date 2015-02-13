class CreateFund < ActiveRecord::Migration
  def change
    create_table :funds do |t|
      t.string :program_code, :org_code, :index_code, :fund_code
      t.timestamps
    end
  end
end
