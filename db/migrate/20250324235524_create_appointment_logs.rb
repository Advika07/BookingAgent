class CreateAppointmentLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :appointment_logs do |t|
      t.uuid :appt_log_id
      t.uuid :client_id
      t.uuid :service_id
      t.uuid :assignment_id
      t.uuid :store_id
      t.uuid :vacancy_id
      t.string :status
      t.uuid :change_by

      t.timestamps
    end
  end
end
