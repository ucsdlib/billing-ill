class AddDescriptionToFunds < ActiveRecord::Migration
  def change
    add_column(:funds, :description, :text)
  end
end
