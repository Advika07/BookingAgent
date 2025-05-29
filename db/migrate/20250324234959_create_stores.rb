class CreateStores < ActiveRecord::Migration[7.1]
  def change
    create_table :stores do |t|
      t.uuid :store_id
      t.string :store_name
      t.string :store_type
      t.string :google_maps_url
      t.string :store_logo_url
      t.string :default_currency
      t.string :timezone
      t.string :booking_page_url
      t.string :store_theme
      t.string :address
      t.string :store_ph
      t.json :operating_hours
      t.uuid :vacancy
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
