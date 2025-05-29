class CreateInventory < ActiveRecord::Migration[7.1]
  def change
    create_table :inventories do |t|
      t.uuid :inventory_id
      t.uuid :store_id
      t.uuid :vendor_id
      t.string :product_category
      t.string :inventory_type
      t.string :product_image
      t.string :product_name
      t.text :product_desc
      t.integer :add_quantity
      t.integer :current_quantity
      t.integer :total_quantity
      t.decimal :product_cost
      t.decimal :product_price
      t.datetime :expiration_date
      t.datetime :last_restock_date
      t.datetime :suggested_restock_date
      t.boolean :is_restocked
      t.string :barcode
      t.integer :threshold_quantity
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
