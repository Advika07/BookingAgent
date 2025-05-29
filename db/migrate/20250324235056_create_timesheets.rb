class CreateTimesheets < ActiveRecord::Migration[7.1]
  def change
    create_table :timesheets do |t|
      t.uuid :timesheet_id
      t.uuid :assignment_id
      t.date :timesheet_date
      t.datetime :clock_in
      t.datetime :clock_out
      t.decimal :hours_worked
      t.boolean :late_clock_in
      t.decimal :overtime_hours
      t.boolean :early_checkout
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
