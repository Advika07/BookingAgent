class CreateInventoryLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :inventory_logs do |t|
      t.uuid :inventory_log_id
      t.uuid :inventory_id
      t.uuid :appointment_id
      t.text :note
      t.string :action_type
      t.integer :quantity_changed

      t.timestamps
    end
  end
end
