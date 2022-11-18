class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.string :image_url
      # redefining price column to accomodate eigit digits of significance (total num of digits) and
      # two digits after decimal point
      t.decimal :price, precision: 8, scale: 2  

      t.timestamps
    end
  end
end
