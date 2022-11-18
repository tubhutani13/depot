class AddColumnsToProducts < ActiveRecord::Migration[7.0]
  def change
    change_table :products do |t|
      t.column :enabled, :boolean
      t.column :discount_price, :decimal
      t.column :permalink, :string
    end
  end
end
