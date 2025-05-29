class CreateLeave < ActiveRecord::Migration[7.1]
  def change
    create_table :leaves do |t|
      t.uuid :leave_id
      t.uuid :assignment_id
      t.string :leave_type
      t.date :leave_date
      t.time :start_time
      t.time :end_time
      t.text :leave_reason
      t.string :leave_status
      t.boolean :approved
      t.uuid :approved_by
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
