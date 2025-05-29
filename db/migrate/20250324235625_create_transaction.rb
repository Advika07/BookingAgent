class CreateTransaction < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.uuid :transaction_id
      t.uuid :store_id
      t.uuid :assignment_id
      t.uuid :appointment_id
      t.decimal :tip_amount
      t.string :promo_code
      t.text :transaction_note
      t.decimal :revenue
      t.decimal :discount
      t.decimal :tax
      t.string :payment_method
      t.text :payment_gateway_response
      t.datetime :processed_date
      t.string :invoice_id
      t.boolean :is_refunded

      t.timestamps
    end
  end
end
