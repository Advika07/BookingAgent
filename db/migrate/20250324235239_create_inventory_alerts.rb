class CreateInventoryAlerts < ActiveRecord::Migration[7.1]
  def change
    create_table :inventory_alerts do |t|
      t.uuid :alert_id
      t.uuid :inventory_id
      t.string :alert_type
      t.string :suggested_action
      t.boolean :is_resolved
      t.datetime :resolved_at

      t.timestamps
    end
  end
end
