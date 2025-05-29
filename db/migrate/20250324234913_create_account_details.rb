class CreateAccountDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :account_details do |t|
      t.uuid :account_details_id
      t.uuid :user_id
      t.uuid :store_id
      t.string :currency
      t.string :bank_account_number
      t.string :bank_name
      t.string :subscription_status
      t.datetime :trial_end_date
      t.boolean :auto_renew
      t.string :billing_cycle
      t.string :payment_method_token
      t.datetime :last_payment_date
      t.string :payment_provider_customerid
      t.string :invoice_email
      t.string :tax_id
      t.datetime :grace_period_end
      t.string :partner_code
      t.string :pricing_plan
      t.string :payout_method
      t.datetime :next_payment_due
      t.datetime :subscription_start_date
      t.string :payment_status
      t.decimal :outstanding_balance
      t.string :reciept_url
      t.datetime :cancelled_at
      t.string :cancellation_reason
      t.text :subscription_notes

      t.timestamps
    end
  end
end
