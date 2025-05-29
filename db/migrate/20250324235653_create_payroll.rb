class CreatePayroll < ActiveRecord::Migration[7.1]
  def change
    create_table :payrolls do |t|
      t.string :financials_payroll
      t.uuid :payroll_id
      t.uuid :assignment_id
      t.decimal :base_salary
      t.decimal :comm_service_per
      t.decimal :comm_inventory_per
      t.decimal :comm_service
      t.decimal :comm_inventory
      t.decimal :bonus
      t.decimal :gross_salary
      t.string :payout_status
      t.datetime :payment_date_actual
      t.string :payout_method
      t.string :approval_status
      t.uuid :approved_by
      t.text :remarks
      t.date :start_date
      t.date :end_date
      t.date :payroll_date

      t.timestamps
    end
  end
end
