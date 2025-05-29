class CreateAppointmentAddOns < ActiveRecord::Migration[7.1]
  def change
    create_table :appointment_add_ons do |t|
      t.uuid :add_on_id
      t.uuid :appointment_id
      t.uuid :inventory_id
      t.integer :quantity
      t.boolean :discounted
      t.decimal :addon_price

      t.timestamps
    end
  end
end
