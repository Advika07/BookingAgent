class CreateStoreStats < ActiveRecord::Migration[7.1]
  def change
    create_table :store_stats do |t|
      t.uuid :store_stats_id
      t.uuid :store_id
      t.decimal :gross_margin
      t.decimal :staff_turnover_rate
      t.decimal :utilisation_peakvsoffpeak
      t.decimal :avg_booking_leadtime
      t.decimal :avg_tip_amt
      t.decimal :no_show_revenue_loss
      t.decimal :waitlist_conversion_rate
      t.decimal :avg_prepayment_rate
      t.integer :total_appts
      t.decimal :noshow_rate
      t.decimal :cancellation_rate
      t.decimal :reschedule_rate
      t.decimal :booking_conversion_rate
      t.decimal :avg_daily_appts
      t.decimal :avg_appt_duration
      t.decimal :workday_utilisation_rate
      t.string :busiest_day
      t.decimal :total_revenue
      t.decimal :avg_revenue_perappt
      t.string :top_service
      t.decimal :inventory_sold_value
      t.decimal :inventory_turnover_rate
      t.integer :active_staff_count
      t.decimal :avg_staff_utilisation
      t.integer :late_clock_ins
      t.string :forecast_type
      t.decimal :forecast_value
      t.datetime :forecast_date
      t.integer :low_stock_alert_count
      t.integer :expired_inventory_count
      t.decimal :avg_days_bw_restock
      t.decimal :inventory_accuracy_rate
      t.decimal :avg_wait_time
      t.decimal :appt_delay_rate
      t.decimal :service_time_variability
      t.decimal :schedule_overrun
      t.decimal :downtime_hours
      t.decimal :peak_hour_efficiency
      t.integer :inventory_stockouts
      t.integer :new_clients
      t.decimal :repeat_visit_rate
      t.decimal :client_retention_rate
      t.string :top_clients

      t.timestamps
    end
  end
end
