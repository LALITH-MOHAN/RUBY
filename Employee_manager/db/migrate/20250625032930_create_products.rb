class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :title
      t.decimal :price
      t.integer :stock

      t.timestamps
    end
  end
end
