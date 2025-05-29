class CreateVendors < ActiveRecord::Migration[7.1]
  def change
    create_table :vendors do |t|
      t.uuid :vendor_id
      t.uuid :store_id
      t.string :vendor_type
      t.string :vendor_name
      t.string :contact_info
      t.text :notes
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
