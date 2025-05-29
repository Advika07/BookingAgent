class CreateShifts < ActiveRecord::Migration[7.1]
  def change
    create_table :shifts do |t|
      t.uuid :shift_id
      t.uuid :assignment_id
      t.date :shift_date
      t.time :start_time
      t.time :end_time
      t.time :break_start
      t.time :break_end
      t.json :days_off
      t.string :scheduled_by
      t.boolean :is_peak_shift
      t.string :block_reason
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
