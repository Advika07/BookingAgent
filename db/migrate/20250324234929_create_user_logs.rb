class CreateUserLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :user_logs do |t|
      t.uuid :log_id
      t.uuid :user_id
      t.string :action_type
      t.string :table_name
      t.string :record_id
      t.text :old_value
      t.text :new_value
      t.uuid :store_id

      t.timestamps
    end
  end
end
