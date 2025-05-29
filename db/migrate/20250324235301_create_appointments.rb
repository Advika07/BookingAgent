class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.uuid :appt_id
      t.uuid :store_id
      t.uuid :assignment_id
      t.uuid :client_id
      t.uuid :service_id
      t.uuid :vacancy_id
      t.datetime :appt_start
      t.datetime :appt_end
      t.string :status
      t.text :appt_notes
      t.boolean :walk_in
      t.decimal :prepayment_amt
      t.boolean :time_alert_triggered
      t.integer :buffer_time
      t.string :payment_status
      t.text :review
      t.string :feedback_sentiment
      t.decimal :discount_applied
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
