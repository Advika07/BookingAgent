class CreateClientStats < ActiveRecord::Migration[7.1]
  def change
    create_table :client_stats do |t|
      t.uuid :client_stats_id
      t.uuid :client_id
      t.uuid :store_id
      t.string :first_visit_state
      t.string :booking_channel_preference
      t.integer :total_appts
      t.boolean :vip_flag
      t.string :last_feedback_sentiment
      t.decimal :frequency
      t.datetime :last_visit
      t.decimal :total_spending
      t.string :most_frequent_service
      t.boolean :predicted_churn
      t.decimal :customer_lifetime_value
      t.integer :no_show_count
      t.decimal :no_show_rate
      t.decimal :discount_usage_rate
      t.decimal :cancellation_rate
      t.decimal :reschedule_rate
      t.string :forecast_type
      t.decimal :churn_risk_score
      t.decimal :forecast_value
      t.datetime :forecast_date
      t.decimal :avg_spending
      t.datetime :last_no_show
      t.string :common_addons
      t.decimal :addon_conversion_rate
      t.string :preferred_day
      t.decimal :review_score_avg
      t.string :common_payment_method

      t.timestamps
    end
  end
end
