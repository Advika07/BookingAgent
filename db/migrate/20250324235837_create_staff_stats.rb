class CreateStaffStats < ActiveRecord::Migration[7.1]
  def change
    create_table :staff_stats do |t|
      t.uuid :staff_stats_id
      t.uuid :assignment_id
      t.decimal :productivity_score
      t.decimal :total_hours_worked
      t.decimal :overwork_risk
      t.decimal :avg_shift_length
      t.decimal :idle_time_percentage
      t.string :forecast_type
      t.decimal :forecast_value
      t.datetime :forecast_date
      t.decimal :avg_idle_time
      t.integer :late_shifts_count
      t.integer :early_leaves_count
      t.json :recommended_shift
      t.integer :staff_total_shifts
      t.decimal :avg_client_rating
      t.decimal :revenue_generated
      t.decimal :avg_revenue
      t.decimal :time_utilisation
      t.integer :days_off_taken
      t.string :most_frequent_service
      t.decimal :on_time_rate

      t.timestamps
    end
  end
end
