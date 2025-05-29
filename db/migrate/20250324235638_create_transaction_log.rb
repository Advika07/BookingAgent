class CreateTransactionLog < ActiveRecord::Migration[7.1]
  def change
    create_table :transaction_logs do |t|
      t.uuid :transaction_log_id
      t.uuid :appointment_id
      t.uuid :store_id
      t.uuid :transaction_id
      t.uuid :assignment_id
      t.uuid :updated_by
      t.decimal :revenue
      t.decimal :discount
      t.decimal :tax
      t.string :payment_method
      t.datetime :processed_date
      t.string :payment_status
      t.text :reason_for_change

      t.timestamps
    end
  end
end
