class AddDocumentNumToRecharges < ActiveRecord::Migration
  def change
    add_column :recharges, :document_num, :integer
  end
end
