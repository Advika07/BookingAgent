class CreateServices < ActiveRecord::Migration[7.1]
  def change
    create_table :services do |t|
      t.uuid :service_id
      t.uuid :store_id
      t.string :service_image
      t.string :service_name
      t.text :service_desc
      t.decimal :service_price
      t.integer :service_duration
      t.boolean :is_featured
      t.string :service_category
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
