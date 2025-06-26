class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :title
      t.decimal :price, precision: 10, scale: 2
      t.string :thumbnail
      t.integer :stock
      t.text :description
      t.string :category

      t.timestamps
    end
  end
end
