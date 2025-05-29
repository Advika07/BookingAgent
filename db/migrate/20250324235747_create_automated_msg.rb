class CreateAutomatedMsg < ActiveRecord::Migration[7.1]
  def change
    create_table :automated_msgs do |t|
      t.uuid :msg_id
      t.string :msg_type
      t.uuid :assignment_id
      t.string :target_audience
      t.string :msg_title
      t.text :msg_content
      t.string :delivery_channel
      t.datetime :scheduled_time
      t.string :frequency
      t.datetime :sent_time
      t.string :delivery_status
      t.json :response_data

      t.timestamps
    end
  end
end
